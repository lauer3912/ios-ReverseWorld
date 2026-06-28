import SwiftUI
import AVFoundation
import CoreImage
import CoreImage.CIFilterBuiltins
import MetalKit

/// R7: Real-time visual effects engine
/// Maps to user's request: 视觉图像幻觉 (visual image hallucination)
/// R8-deferred: Real-time Metal rendering is complex; for now we expose
/// the CIFilter pipeline + post-capture filter application.
final class VisualEffectsEngine: NSObject, ObservableObject {
    @Published var currentFilter: VisualFilter = .none
    @Published private(set) var isAuthorized: Bool = false
    @Published private(set) var isPermanentlyDenied: Bool = false
    @Published var error: String?

    let context = CIContext()

    private var hasSetup = false

    /// R7: Authoritative permission check (read-only)
    func refreshAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            isPermanentlyDenied = false
        case .denied, .restricted:
            isAuthorized = false
            isPermanentlyDenied = true
        case .notDetermined:
            isAuthorized = false
            isPermanentlyDenied = false
        @unknown default:
            isAuthorized = false
            isPermanentlyDenied = true
        }
    }

    /// R7: User-action trigger
    func requestAccess() {
        guard !hasSetup else { return }
        hasSetup = true
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
            }
        }
    }

    /// R7: Apply current filter to a still UIImage (for post-capture use)
    func applyFilter(to image: UIImage) -> UIImage {
        guard currentFilter != .none else { return image }
        guard let ciImage = CIImage(image: image) else { return image }
        guard let filtered = currentFilter.apply(to: ciImage) else { return image }
        guard let cgImage = context.createCGImage(filtered, from: filtered.extent) else { return image }
        return UIImage(cgImage: cgImage)
    }
}

/// Visual filters that can be applied to images / camera feed
enum VisualFilter: String, CaseIterable, Identifiable, Hashable {
    case none = "Original"
    case mirror = "Mirror"
    case invert = "Invert"
    case hueRotate = "Hue Shift"
    case posterize = "Posterize"
    case noir = "Noir"
    case chrome = "Chrome"
    case sepia = "Sepia"
    case instant = "Instant"
    case mono = "Mono"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .none: return "eye"
        case .mirror: return "rectangle.portrait.righthalf.filled"
        case .invert: return "circle.lefthalf.filled"
        case .hueRotate: return "paintpalette"
        case .posterize: return "square.grid.3x3"
        case .noir: return "moon.stars"
        case .chrome: return "camera.filters"
        case .sepia: return "camera.macro"
        case .instant: return "camera"
        case .mono: return "circle.righthalf.filled"
        }
    }

    /// Apply filter to a CIImage. Returns nil for .none
    func apply(to image: CIImage) -> CIImage? {
        switch self {
        case .none:
            return nil
        case .mirror:
            // Mirror horizontally
            let translated = image.transformed(by: CGAffineTransform(translationX: -image.extent.width, y: 0))
            return translated.transformed(by: CGAffineTransform(scaleX: -1, y: 1))
        case .invert:
            return image.applyingFilter("CIColorInvert")
        case .hueRotate:
            return image.applyingFilter("CIHueAdjust", parameters: ["inputAngle": Double.pi])
        case .posterize:
            return image.applyingFilter("CIColorPosterize", parameters: ["inputLevels": 4])
        case .noir:
            return image.applyingFilter("CIPhotoEffectNoir")
        case .chrome:
            return image.applyingFilter("CIPhotoEffectChrome")
        case .sepia:
            return image.applyingFilter("CISepiaTone", parameters: ["inputIntensity": 0.8])
        case .instant:
            return image.applyingFilter("CIPhotoEffectInstant")
        case .mono:
            return image.applyingFilter("CIPhotoEffectMono")
        }
    }
}
