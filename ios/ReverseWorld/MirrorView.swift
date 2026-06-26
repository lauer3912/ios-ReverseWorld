import SwiftUI
import AVFoundation

struct MirrorView: View {
    @State private var isMirrored = true
    @State private var showCaptureEffect = false
    @StateObject private var camera = CameraController()

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0a0a1a")
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Mirror Frame
                    ZStack {
                        // Real camera preview (or placeholder if no access)
                        if camera.isAuthorized {
                            CameraPreview(camera: camera)
                                .clipShape(RoundedRectangle(cornerRadius: 200))
                                .frame(width: 280, height: 380)
                                .scaleEffect(x: isMirrored ? -1 : 1, y: 1)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 200)
                                        .stroke(
                                            LinearGradient(
                                                colors: [.yellow, .orange],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 8
                                        )
                                )
                        } else {
                            RoundedRectangle(cornerRadius: 200)
                                .fill(
                                    LinearGradient(
                                        colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 280, height: 380)
                                .overlay(
                                    VStack {
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(.white.opacity(0.3))
                                        Text(camera.error ?? "Tap to enable camera")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.5))
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal)
                                    }
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 200)
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
                                    camera.checkAuthorization()
                                }
                        }

                        // Capture flash effect
                        if showCaptureEffect {
                            Rectangle()
                                .fill(.white)
                                .transition(.opacity)
                        }
                    }
                    .padding(.top, 40)

                    // Controls
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
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Color(hex: "1a0a2e"))
                            .clipShape(Circle())
                        }

                        Button {
                            capturePhoto()
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(Color.white, lineWidth: 4)
                                    .frame(width: 70, height: 70)
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 56, height: 56)
                            }
                        }
                        .disabled(!camera.isAuthorized)

                        Button {
                            // Switch camera
                            camera.flipCamera()
                        } label: {
                            VStack {
                                Image(systemName: "camera.rotate.fill")
                                    .font(.title)
                                Text("Flip")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .frame(width: 80, height: 80)
                            .background(Color(hex: "1a0a2e"))
                            .clipShape(Circle())
                        }
                    }
                    .padding(.top, 20)

                    Spacer()

                    // Mirror Tips
                    VStack(spacing: 8) {
                        Text("Mirror Tip")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                        Text("Use your non-dominant hand in mirror to challenge your brain!")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color(hex: "1a0a2e"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Mirror World")
            .navigationBarTitleDisplayMode(.inline)
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
    }
}

#Preview {
    MirrorView()
}