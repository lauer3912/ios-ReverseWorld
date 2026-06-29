import SwiftUI
import AVFoundation
import UIKit

/// Real camera preview using AVCaptureSession
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera: CameraController

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.videoPreviewLayer.session = camera.session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        uiView.videoPreviewLayer.session = camera.session
    }

    /// Custom UIView with AVCaptureVideoPreviewLayer
    final class PreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
    }
}

/// Camera controller managing AVCaptureSession
final class CameraController: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate {
    @Published var isAuthorized: Bool = false
    @Published var isPermanentlyDenied: Bool = false  // M1: differentiate denied from notDetermined
    @Published var isFrontCamera: Bool = true
    @Published var capturedImage: UIImage?
    @Published var error: String?
    @Published var useFlash: Bool = false  // C3: flash toggle

    let session = AVCaptureSession()

    private let sessionQueue = DispatchQueue(label: "ReverseWorld.CameraSessionQueue")
    private var photoOutput: AVCapturePhotoOutput?
    private var currentInput: AVCaptureDeviceInput?
    private var hasSetup = false  // 防止 requestCameraAccess 重复弹 iOS 弹窗

    override init() {
        super.init()
        // NEVER call AVCaptureDevice.requestAccess in init.
        // iOS permission dialog is a system-level modal that persists across views.
        // Only query the current status silently.
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            isAuthorized = true
            // 🔧 Fix 09:35 CST bug: 关闭 App 重启后, MirrorView 显示黑屏/没预览
            // 原因: init 只设 isAuthorized=true 但没调 configureSession()
            //      → AVCaptureSession 没启动 → 预览层没东西显示
            // Fix: authorized 时主动 configureSession, 让重启 App 后 camera 立即可用
            configureSession()
        case .denied, .restricted:
            isPermanentlyDenied = true
            error = "Camera access denied. Please enable in Settings."
        default:
            break
        }
    }

    /// Call from user action (button tap) to trigger the iOS permission dialog.
    /// Safe: only shows dialog on user's explicit input, not on view init.
    func requestCameraAccess() {
        guard !hasSetup else { return }
        hasSetup = true
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            isPermanentlyDenied = false
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted { self?.configureSession() }
                }
            }
        case .denied, .restricted:
            isPermanentlyDenied = true
            error = "Camera access denied. Please enable in Settings."
        @unknown default:
            break
        }
    }

    private func configureSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            let photoOutput = AVCapturePhotoOutput()
            if self.session.canAddOutput(photoOutput) {
                self.session.addOutput(photoOutput)
                self.photoOutput = photoOutput
            }

            self.addCameraInput(position: self.isFrontCamera ? .front : .back)
            self.session.commitConfiguration()
            self.session.startRunning()
        }
    }

    private func addCameraInput(position: AVCaptureDevice.Position) {
        session.beginConfiguration()
        if let currentInput = currentInput {
            session.removeInput(currentInput)
        }
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: camera),
              session.canAddInput(input) else {
            session.commitConfiguration()
            // C2: publish error instead of silent return
            DispatchQueue.main.async { [weak self] in
                self?.error = "Could not access camera in this position"
            }
            return
        }
        session.addInput(input)
        currentInput = input
        session.commitConfiguration()
    }

    func flipCamera() {
        isFrontCamera.toggle()
        sessionQueue.async { [weak self] in
            self?.addCameraInput(position: self?.isFrontCamera == true ? .front : .back)
        }
    }

    func capturePhoto() {
        guard let photoOutput = photoOutput else { return }
        let settings = AVCapturePhotoSettings()
        // C3: respect user flash preference
        if useFlash && photoOutput.supportedFlashModes.contains(.on) {
            settings.flashMode = .on
        } else {
            settings.flashMode = .off
        }
        // C4: weak delegate would not work for AVCapturePhotoCaptureDelegate, but we set the controller as its own delegate
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            AppLog.camera.error("Capture failed: \(error.localizedDescription, privacy: .public)")
            DispatchQueue.main.async { [weak self] in
                self?.error = "Capture failed: \(error.localizedDescription)"
            }
            return
        }
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = image
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
