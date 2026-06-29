//
//  PermissionsManager.swift
//  ReverseWorld
//
//  Centralized permission state + grant flow for camera/mic/photo/speech.
//  Per Apple HIG: don't pre-request at launch — request when context is clear,
//  handle 3 states (authorized / denied / notDetermined), provide easy Settings redirect.
//
//  Created: 2026-06-29 09:06 CST (Katherine-E2wa1m, per 佛老爷 "摄像头和相册权限优化")
//

import SwiftUI
import AVFoundation
import Photos
import Speech

/// Status of a single permission
enum PermissionStatus: Equatable {
    case authorized
    case denied       // user denied — must go to Settings
    case restricted   // parental controls / MDM — can't grant
    case notDetermined  // never asked yet

    var isGranted: Bool { self == .authorized }

    var iconName: String {
        switch self {
        case .authorized: return "checkmark.circle.fill"
        case .denied: return "xmark.circle.fill"
        case .restricted: return "lock.circle.fill"
        case .notDetermined: return "questionmark.circle.fill"
        }
    }

    var displayLabel: String {
        switch self {
        case .authorized: return "Granted"
        case .denied: return "Denied — Open Settings"
        case .restricted: return "Restricted"
        case .notDetermined: return "Not yet asked"
        }
    }

    var tintColor: Color {
        switch self {
        case .authorized: return .green
        case .denied: return .red
        case .restricted: return .orange
        case .notDetermined: return .gray
        }
    }
}

/// Centralized manager for camera/mic/photo/speech permissions.
/// Lives as @StateObject in ContentView so all child views can observe.
@MainActor
final class PermissionsManager: ObservableObject {

    // MARK: - Published State

    @Published var camera: PermissionStatus = .notDetermined
    @Published var microphone: PermissionStatus = .notDetermined
    @Published var photoLibrary: PermissionStatus = .notDetermined
    @Published var photoAddOnly: PermissionStatus = .notDetermined
    @Published var speechRecognition: PermissionStatus = .notDetermined

    @Published var lastDeniedPermission: String?  // for "Open Settings" alert

    // MARK: - Init

    init() {
        refreshAll()
    }

    // MARK: - Refresh (read current status, no prompt)

    func refreshAll() {
        camera = Self.cameraStatus()
        microphone = Self.microphoneStatus()
        let photoPair = Self.photoLibraryStatusPair()
        photoLibrary = photoPair.readWrite
        photoAddOnly = photoPair.addOnly
        speechRecognition = Self.speechStatus()
    }

    // MARK: - Request (triggers system prompt)

    /// Request camera. Returns new status after the prompt.
    func requestCamera() async -> PermissionStatus {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        camera = granted ? .authorized : (Self.cameraStatus())
        if !granted && camera == .denied { lastDeniedPermission = "Camera" }
        return camera
    }

    /// Request microphone. Returns new status after the prompt.
    func requestMicrophone() async -> PermissionStatus {
        let granted = await AVCaptureDevice.requestAccess(for: .audio)
        microphone = granted ? .authorized : (Self.microphoneStatus())
        if !granted && microphone == .denied { lastDeniedPermission = "Microphone" }
        return microphone
    }

    /// Request photo library (read+write). Returns new status.
    func requestPhotoLibrary() async -> PermissionStatus {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        photoLibrary = Self.statusFromPHPhoto(status)
        if photoLibrary == .denied { lastDeniedPermission = "Photo Library" }
        return photoLibrary
    }

    /// Request add-only photo permission (iOS 14+).
    func requestPhotoAddOnly() async -> PermissionStatus {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        photoAddOnly = Self.statusFromPHPhoto(status)
        if photoAddOnly == .denied { lastDeniedPermission = "Photo Save" }
        return photoAddOnly
    }

    /// Request speech recognition (callback-based → wrap in continuation).
    func requestSpeechRecognition() async -> PermissionStatus {
        let status: SFSpeechRecognizerAuthorizationStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { newStatus in
                continuation.resume(returning: newStatus)
            }
        }
        speechRecognition = Self.statusFromSpeech(status)
        if speechRecognition == .denied { lastDeniedPermission = "Speech Recognition" }
        return speechRecognition
    }

    // MARK: - Convenience: request both camera + mic at once (for MirrorView)

    /// MirrorView needs both. Returns true only if both granted.
    @discardableResult
    func requestCameraAndMicrophone() async -> (camera: PermissionStatus, microphone: PermissionStatus) {
        let cam = await requestCamera()
        let mic = await requestMicrophone()
        return (cam, mic)
    }

    // MARK: - Settings redirect (for denied state)

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - Static helpers (read current status without prompting)

    static func cameraStatus() -> PermissionStatus {
        let raw = AVCaptureDevice.authorizationStatus(for: .video)
        return Self.statusFromAV(raw)
    }

    static func microphoneStatus() -> PermissionStatus {
        let raw = AVCaptureDevice.authorizationStatus(for: .audio)
        return Self.statusFromAV(raw)
    }

    static func photoLibraryStatusPair() -> (readWrite: PermissionStatus, addOnly: PermissionStatus) {
        let rw = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        let ao = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        return (Self.statusFromPHPhoto(rw), Self.statusFromPHPhoto(ao))
    }

    static func speechStatus() -> PermissionStatus {
        Self.statusFromSpeech(SFSpeechRecognizer.authorizationStatus())
    }

    private static func statusFromAV(_ raw: AVAuthorizationStatus) -> PermissionStatus {
        switch raw {
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }

    private static func statusFromPHPhoto(_ raw: PHAuthorizationStatus) -> PermissionStatus {
        switch raw {
        case .authorized, .limited: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }

    private static func statusFromSpeech(_ raw: SFSpeechRecognizerAuthorizationStatus) -> PermissionStatus {
        switch raw {
        case .authorized: return .authorized
        case .denied: return .denied
        case .restricted: return .restricted
        case .notDetermined: return .notDetermined
        @unknown default: return .notDetermined
        }
    }

    // MARK: - Aggregate helpers

    /// Are all critical permissions (camera + mic + photo) granted?
    var allCriticalGranted: Bool {
        camera.isGranted && microphone.isGranted && photoLibrary.isGranted
    }

    /// Total granted count (for "X/5 permissions granted" UI)
    var grantedCount: Int {
        [camera, microphone, photoLibrary, photoAddOnly, speechRecognition]
            .filter { $0.isGranted }
            .count
    }

    var totalCount: Int { 5 }
}