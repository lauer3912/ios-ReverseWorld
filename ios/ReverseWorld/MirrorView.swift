import SwiftUI
import AVFoundation

struct MirrorView: View {
    @State private var isMirrored = true
    @State private var showCaptureEffect = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0a0a1a")
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    // Mirror Frame
                    ZStack {
                        // Simulated mirror view (in real app, this would be camera)
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

                        // Placeholder text
                        VStack {
                            Image(systemName: "person.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.3))
                            Text("Camera Preview")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .scaleEffect(isMirrored ? -1 : 1)

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

                        Button {
                            // Switch camera
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
    }
}

#Preview {
    MirrorView()
}