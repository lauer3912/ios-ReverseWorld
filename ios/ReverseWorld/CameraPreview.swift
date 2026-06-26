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
        if camera.connection != nil {
            camera.attachPreview()
        }
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
    @Published var isFrontCamera: Bool = true
    @Published var capturedImage: UIImage?
    @Published var error: String?

    let session = AVCaptureSession()
    var connection: AVCaptureConnection?

    private let sessionQueue = DispatchQueue(label: "ReverseWorld.CameraSessionQueue")
    private var photoOutput: AVCapturePhotoOutput?
    private var currentInput: AVCaptureDeviceInput?

    override init() {
        super.init()
        checkAuthorization()
    }

    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            configureSession()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted { self?.configureSession() }
                }
            }
        default:
            isAuthorized = false
            error = "Camera access denied. Please enable in Settings."
        }
    }

    private func configureSession() {
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            self.session.beginConfiguration()
            self.session.sessionPreset = .photo

            // Add photo output
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
            return
        }
        session.addInput(input)
        currentInput = input
        session.commitConfiguration()
    }

    func attachPreview() {
        // Configure connection mirroring
        sessionQueue.async { [weak self] in
            guard let self = self else { return }
            // Find video connection and set mirroring
            if let videoOutput = self.session.outputs.first as? AVCaptureVideoDataOutput {
                self.connection = videoOutput.connection(with: .video)
            } else {
                // For photo output, we don't need a connection
                self.connection = nil
            }
        }
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
        settings.flashMode = .off
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            DispatchQueue.main.async { [weak self] in
                self?.error = "Capture failed: \(error.localizedDescription)"
            }
            return
        }
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = image
            // Save to photo library
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
}
