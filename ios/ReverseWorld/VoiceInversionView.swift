import SwiftUI
import AVFoundation

/// Voice Inversion - "Secrets hidden in sound"
/// Maps to user's request: 声音中隐含的秘密
/// User records audio, we reverse it, user plays back to discover "hidden" content
struct VoiceInversionView: View {
    @StateObject private var service = AudioInversionService()
    @State private var showPermissionAlert = false
    @State private var showReveal = false

    var body: some View {
        Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                // iPad: skip NavigationStack (per #44 #5)
                ZStack {
                    Theme.Background.primary.ignoresSafeArea()
                    ScrollView {
                        VStack(spacing: Theme.Layout.sectionSpacing) {
                            header
                            if service.reversedURL != nil {
                                playbackControls
                                revealSection
                            } else {
                                recordingCard
                            }
                            if let error = service.error {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(Theme.Accent.danger)
                                    .padding()
                            }
                            Spacer(minLength: 40)
                        }
                        .padding()
                    }
                }
            } else {
                // iPhone: NavigationStack for navigation title
                NavigationStack {
                    ZStack {
                        Theme.Background.primary.ignoresSafeArea()
                        ScrollView {
                            VStack(spacing: Theme.Layout.sectionSpacing) {
                                header
                                if service.reversedURL != nil {
                                    playbackControls
                                    revealSection
                                } else {
                                    recordingCard
                                }
                                if let error = service.error {
                                    Text(error)
                                        .font(.caption)
                                        .foregroundColor(Theme.Accent.danger)
                                        .padding()
                                }
                                Spacer(minLength: 40)
                            }
                            .padding()
                        }
                    }
                    .navigationTitle(L10n.voiceTitle)
                    .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .alert(L10n.micDeniedTitle, isPresented: $showPermissionAlert) {
            Button(L10n.openSettings) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            Button(L10n.cancel, role: .cancel) {}
        } message: {
            Text(L10n.micDeniedMessage)
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "waveform.badge.magnifyingglass")
                .font(.system(size: 50))
                .foregroundStyle(LinearGradient(colors: [.purple, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .accessibilityHidden(true)
            Text(L10n.voiceTagline)
                .font(.subheadline)
                .foregroundColor(Theme.Text.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 20)
    }

    private var recordingCard: some View {
        VStack(spacing: 24) {
            // Big circular record button
            Button {
                Task { await handleRecord() }
            } label: {
                ZStack {
                    Circle()
                        .fill(service.isRecording ? Color.red : Theme.Accent.primary)
                        .frame(width: 140, height: 140)
                        .shadow(color: (service.isRecording ? Color.red : Theme.Accent.primary).opacity(0.4), radius: 20)
                    if service.isRecording {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                    } else {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            .accessibilityLabel(service.isRecording ? L10n.voiceStop : L10n.voiceRecord)
            .scaleEffect(service.isRecording ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: service.isRecording)

            if service.isRecording {
                Text(formatTime(service.recordingDuration))
                    .font(.system(size: 32, weight: .bold, design: .monospaced))
                    .foregroundColor(Theme.Accent.danger)
            } else {
                Text(L10n.voiceTapToRecord)
                    .font(.caption)
                    .foregroundColor(Theme.Text.tertiary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.largeRadius))
    }

    private var playbackControls: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                // Original button
                Button {
                    service.play(reversed: false)
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "play.fill")
                            .font(.title2)
                        Text(L10n.voiceOriginal)
                            .font(.caption)
                    }
                    .foregroundColor(Theme.Text.primary)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.Background.elevated)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                }
                .accessibilityLabel(L10n.voicePlayOriginal)

                // Reversed button (highlighted)
                Button {
                    service.play(reversed: true)
                } label: {
                    VStack(spacing: 6) {
                        Image(systemName: "backward.fill")
                            .font(.title2)
                        Text(L10n.voiceReversed)
                            .font(.caption)
                    }
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(LinearGradient(colors: [Theme.Accent.warning, Color.orange], startPoint: .leading, endPoint: .trailing))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                }
                .accessibilityLabel(L10n.voicePlayReversed)
            }

            if service.isPlaying {
                ProgressView(value: service.playbackProgress)
                    .tint(Theme.Accent.warning)
                Button(L10n.voiceStop) {
                    service.stopPlayback()
                }
                .foregroundColor(Theme.Accent.danger)
            }

            // Re-record button
            Button {
                service.stopPlayback()
                Task { await handleRecord() }
            } label: {
                Label(L10n.voiceReRecord, systemImage: "arrow.counterclockwise")
                    .font(.subheadline)
                    .foregroundColor(Theme.Text.secondary)
            }
        }
        .padding()
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.largeRadius))
    }

    private var revealSection: some View {
        VStack(spacing: 12) {
            Image(systemName: showReveal ? "eye.fill" : "eye.slash")
                .font(.title)
                .foregroundColor(Theme.Accent.warning)
            Text(showReveal ? L10n.voiceRevealOn : L10n.voiceRevealOff)
                .font(.headline)
                .foregroundColor(Theme.Text.primary)
            Text(L10n.voiceRevealDescription)
                .font(.caption)
                .foregroundColor(Theme.Text.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button {
                withAnimation {
                    showReveal.toggle()
                }
            } label: {
                Text(showReveal ? L10n.voiceHide : L10n.voiceRevealButton)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Theme.Accent.warning)
                    .clipShape(Capsule())
            }
        }
        .padding()
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.largeRadius))
    }

    // MARK: - Actions

    private func handleRecord() async {
        if service.isRecording {
            service.stopRecording()
        } else {
            let granted = await service.requestPermission()
            if granted {
                service.startRecording()
            } else {
                showPermissionAlert = true
            }
        }
    }

    private func formatTime(_ seconds: TimeInterval) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

#Preview {
    VoiceInversionView()
}
