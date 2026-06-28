import SwiftUI
import AVFoundation
import UIKit

struct MirrorView: View {
    @State private var isMirrored = true
    @State private var showCaptureEffect = false
    @State private var showSavedAlert = false
    @State private var showPermissionAlert = false
    @StateObject private var camera = CameraController()
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Background.primary
                    .ignoresSafeArea()

                VStack(spacing: Theme.Layout.sectionSpacing) {
                    // Mirror Frame
                    ZStack {
                        if camera.isAuthorized {
                            CameraPreview(camera: camera)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.Card.pillRadius))
                                .frame(maxWidth: 360, maxHeight: 480)  // M4: adaptive instead of fixed 280x380
                                .scaleEffect(x: isMirrored ? -1 : 1, y: 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.Card.pillRadius)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.yellow, .orange],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 8
                                        )
                                )
                                .accessibilityLabel("Live camera mirror preview")
                        } else {
                            // M1: differentiated tap action based on permission state
                            RoundedRectangle(cornerRadius: Theme.Card.pillRadius)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(maxWidth: 360, maxHeight: 480)
                                .overlay(
                                    VStack {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(Theme.Text.disabled)
                                        Text(camera.error ?? "Tap to enable camera")
                                            .font(.caption)
                                            .foregroundColor(Theme.Text.tertiary)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: Theme.Card.pillRadius)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.yellow, .orange],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 8
                                        )
                                )
                                .onTapGesture {
                                    if camera.isPermanentlyDenied {
                                        showPermissionAlert = true
                                    } else {
                                        camera.requestCameraAccess()
                                    }
                                }
                                .accessibilityAddTraits(.isButton)
                                .accessibilityLabel(camera.isPermanentlyDenied ? "Camera denied, tap to open Settings" : "Enable camera access")
                        }

                        if showCaptureEffect {
                            Rectangle()
                                .fill(.white)
                                .transition(.opacity)
                        }
                    }
                    .padding(.top, 40)

                    HStack(spacing: 40) {
                        Button {
                            withAnimation(.spring()) {
                                isMirrored.toggle()
                            }
                        } label: {
                            VStack {
                                Image(systemName: isMirrored ? "arrow.left.and.right.righttriangle.left.righttriangle.right.fill" : "arrow.left.and.right.righttriangle.left.righttriangle.right")
                                    .font(.title)
                                Text(isMirrored ? "Mirrored" : "Normal")
                                    .font(.caption)
                            }
                            .foregroundColor(Theme.Text.primary)
                            .frame(width: 80, height: 80)
                            .background(Theme.Background.card)
                            .clipShape(Circle())
                        }
                        .sensoryFeedback(.impact, trigger: isMirrored)  // M3
                        .accessibilityLabel(isMirrored ? "Currently mirrored, tap to disable" : "Currently normal, tap to mirror")

                        Button {
                            capturePhoto()
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Theme.Text.primary, lineWidth: 4)
                                    .frame(width: 70, height: 70)
                                Circle()
                                    .fill(Theme.Text.primary)
                                    .frame(width: 56, height: 56)
                            }
                        }
                        .disabled(!camera.isAuthorized)
                        .accessibilityLabel("Capture photo")

                        Button {
                            camera.flipCamera()
                        } label: {
                            VStack {
                                Image(systemName: "camera.rotate.fill")
                                    .font(.title)
                                Text("Flip")
                                    .font(.caption)
                            }
                            .foregroundColor(Theme.Text.primary)
                            .frame(width: 80, height: 80)
                            .background(Theme.Background.card)
                            .clipShape(Circle())
                        }
                        .sensoryFeedback(.impact, trigger: camera.isFrontCamera)
                        .accessibilityLabel("Switch camera")
                    }
                    .padding(.top, 20)

                    Spacer()

                    VStack(spacing: 8) {
                        Text("Mirror Tip")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(Theme.Accent.warning)
                        Text("Use your non-dominant hand in mirror to challenge your brain!")
                            .font(.caption)
                            .foregroundColor(Theme.Text.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Theme.Background.card)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Mirror World")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)  // M7: hide nav bar in this nested view
            // M2: photo saved alert
            .alert("Saved to Photos", isPresented: $showSavedAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your mirror photo has been added to your photo library.")
            }
            // M1: redirect to Settings when permanently denied
            .alert("Camera Access Denied", isPresented: $showPermissionAlert) {
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        openURL(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable camera access for ReverseWorldGo in Settings to use the mirror feature.")
            }
        }
    }

    func capturePhoto() {
        withAnimation {
            showCaptureEffect = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            showCaptureEffect = false
        }
        camera.capturePhoto()
        showSavedAlert = true  // M2
    }
}

#Preview {
    MirrorView()
}
