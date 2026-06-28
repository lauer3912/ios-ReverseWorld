import SwiftUI
import AVFoundation

/// R7: Video Reversal - record short video, play it backwards
/// Maps to user's request: 真实事件的反转 (real event reversal)
/// Uses AVPlayer.rate = -1 for true reverse playback
struct VideoInversionView: View {
    @State private var isRecording = false
    @State private var recordedURL: URL?
    @State private var error: String?
    @StateObject private var recorder = VideoInversionRecorder()
    @State private var isReversed = false
    @State private var isPlaying = false

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.Background.primary.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: Theme.Layout.sectionSpacing) {
                        header
                        if let url = recordedURL {
                            playbackSection(url: url)
                            recordAgainButton
                        } else {
                            recordSection
                        }
                        if let error = error {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(Theme.Accent.danger)
                        }
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle(L10n.videoTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onDisappear { recorder.cleanup() }
    }

    private var header: some View {
        VStack(spacing: 8) {
            Image(systemName: "video.bubble.left")
                .font(.system(size: 50))
                .foregroundStyle(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
            Text(L10n.videoTagline)
                .font(.subheadline)
                .foregroundColor(Theme.Text.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 20)
    }

    private var recordSection: some View {
        VStack(spacing: 24) {
            Button {
                if recorder.isRecording {
                    recorder.stopRecording { url in
                        recordedURL = url
                        error = nil
                    }
                } else {
                    do {
                        try recorder.startRecording()
                        error = nil
                    } catch {
                        self.error = "Cannot record: \(error.localizedDescription)"
                    }
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(recorder.isRecording ? Color.red : Theme.Accent.primary)
                        .frame(width: 140, height: 140)
                    if recorder.isRecording {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.white)
                            .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "video.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                }
            }
            .accessibilityLabel(recorder.isRecording ? L10n.voiceStop : L10n.videoRecord)

            Text(recorder.isRecording ? L10n.videoRecordingHint : L10n.videoTapToRecord)
                .font(.caption)
                .foregroundColor(Theme.Text.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.largeRadius))
    }

    @ViewBuilder
    private func playbackSection(url: URL) -> some View {
        VStack(spacing: 16) {
            // Video player
            VideoPlayerView(url: url, isReversed: $isReversed, isPlaying: $isPlaying)
                .frame(height: 280)
                .clipShape(RoundedRectangle(cornerRadius: Theme.Card.largeRadius))

            HStack(spacing: 16) {
                // Forward button
                Button {
                    isReversed = false
                } label: {
                    HStack {
                        Image(systemName: "play.fill")
                        Text(L10n.voiceOriginal)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(!isReversed ? Theme.Accent.primary : Theme.Background.elevated)
                    .foregroundColor(Theme.Text.primary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                }
                .accessibilityLabel(L10n.voicePlayOriginal)

                // Reverse button
                Button {
                    isReversed = true
                } label: {
                    HStack {
                        Image(systemName: "backward.fill")
                        Text(L10n.voiceReversed)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isReversed ? LinearGradient(colors: [Theme.Accent.warning, Color.orange], startPoint: .leading, endPoint: .trailing) : LinearGradient(colors: [Theme.Background.elevated, Theme.Background.elevated], startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(isReversed ? .black : Theme.Text.primary)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.Card.cornerRadius))
                }
                .accessibilityLabel(L10n.voicePlayReversed)
            }

            Text(isReversed ? L10n.videoReverseOn : L10n.videoReverseOff)
                .font(.caption)
                .foregroundColor(Theme.Text.tertiary)
        }
        .padding()
        .background(Theme.Background.card)
        .clipShape(RoundedRectangle(cornerRadius: Theme.Card.largeRadius))
    }

    private var recordAgainButton: some View {
        Button {
            recordedURL = nil
            isReversed = false
            isPlaying = false
        } label: {
            Label(L10n.videoRecordAgain, systemImage: "arrow.counterclockwise")
                .font(.subheadline)
                .foregroundColor(Theme.Text.secondary)
        }
    }
}

/// Video recorder using AVCaptureMovieFileOutput
final class VideoInversionRecorder: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    @Published private(set) var isRecording = false
    @Published var error: String?
    @Published var recordingDuration: TimeInterval = 0

    private var session: AVCaptureSession?
    private let movieOutput = AVCaptureMovieFileOutput()
    private var timer: Timer?
    private var recordingStart: Date?
    private var completion: ((URL?) -> Void)?

    func startRecording() throws {
        let captureSession = AVCaptureSession()
        captureSession.beginConfiguration()
        captureSession.sessionPreset = .high

        // Remove existing
        for input in captureSession.inputs { captureSession.removeInput(input) }
        for output in captureSession.outputs { captureSession.removeOutput(output) }

        // Add video input
        if let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
           let input = try? AVCaptureDeviceInput(device: camera),
           captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }

        // Add audio
        if let mic = AVCaptureDevice.default(for: .audio),
           let micInput = try? AVCaptureDeviceInput(device: mic),
           captureSession.canAddInput(micInput) {
            captureSession.addInput(micInput)
        }

        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }

        captureSession.commitConfiguration()
        self.session = captureSession
        captureSession.startRunning()

        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("video-\(UUID().uuidString).mov")

        movieOutput.startRecording(to: outputURL, recordingDelegate: self)
        isRecording = true
        recordingStart = Date()
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.recordingStart else { return }
            self.recordingDuration = Date().timeIntervalSince(start)
        }
    }

    func stopRecording(completion: @escaping (URL?) -> Void) {
        self.completion = completion
        movieOutput.stopRecording()
        timer?.invalidate()
        timer = nil
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            self.isRecording = false
            if let error = error {
                self.error = error.localizedDescription
                self.completion?(nil)
            } else {
                self.completion?(outputFileURL)
            }
        }
    }

    func cleanup() {
        timer?.invalidate()
        session?.stopRunning()
    }
}

/// SwiftUI wrapper for AVPlayer with reverse playback
struct VideoPlayerView: UIViewRepresentable {
    let url: URL
    @Binding var isReversed: Bool
    @Binding var isPlaying: Bool

    func makeUIView(context: Context) -> UIView {
        return PlayerContainerView(url: url, isReversed: isReversed, isPlaying: $isPlaying)
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let container = uiView as? PlayerContainerView else { return }
        container.update(url: url, isReversed: isReversed)
    }
}

class PlayerContainerView: UIView {
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var url: URL
    private var isReversed: Bool
    private var rateObservation: NSKeyValueObservation?

    init(url: URL, isReversed: Bool, isPlaying: Binding<Bool>) {
        self.url = url
        self.isReversed = isReversed
        super.init(frame: .zero)
        backgroundColor = .black
        setupPlayer()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupPlayer() {
        let p = AVPlayer(url: url)
        let layer = AVPlayerLayer(player: p)
        layer.videoGravity = .resizeAspect
        layer.frame = bounds
        self.layer.addSublayer(layer)
        self.playerLayer = layer
        self.player = p
        p.play()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }

    func update(url: URL, isReversed: Bool) {
        let wasReversed = self.isReversed
        self.url = url
        self.isReversed = isReversed
        guard let p = player else { return }

        if isReversed != wasReversed {
            // Toggle reverse playback
            if isReversed {
                p.rate = -1.0
            } else {
                p.rate = 1.0
            }
        }
    }
}
