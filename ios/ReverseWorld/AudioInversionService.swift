import Foundation
import AVFoundation
import Combine

/// Service for recording + reversing audio (Voice Inversion / "secrets hidden in sound")
/// Maps to user's request: 声音中隐含的秘密 (secrets hidden in sound)
@MainActor
final class AudioInversionService: NSObject, ObservableObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    @Published private(set) var isRecording = false
    @Published private(set) var isPlaying = false
    @Published private(set) var recordingDuration: TimeInterval = 0
    @Published private(set) var playbackProgress: Double = 0
    @Published private(set) var originalURL: URL?
    @Published private(set) var reversedURL: URL?
    @Published var error: String?

    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var recordingStart: Date?
    private var recordingTimer: Timer?
    private var playbackTimer: Timer?

    private let session = AVAudioSession.sharedInstance()

    // MARK: - Permission

    func requestPermission() async -> Bool {
        if #available(iOS 17.0, *) {
            return await AVAudioApplication.requestRecordPermission()
        } else {
            return await withCheckedContinuation { cont in
                session.requestRecordPermission { granted in
                    cont.resume(returning: granted)
                }
            }
        }
    }

    // MARK: - Recording

    func startRecording() {
        do {
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)
        } catch let sessionError {
            error = "Audio session error: \(sessionError.localizedDescription)"
            return
        }

        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("recording-\(UUID().uuidString).caf")

        // Linear PCM 16-bit, 44.1kHz, mono - easy to reverse
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsBigEndianKey: false,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsNonInterleaved: false
        ]

        do {
            let rec = try AVAudioRecorder(url: url, settings: settings)
            rec.delegate = self
            rec.prepareToRecord()
            rec.record()
            recorder = rec
            originalURL = url
            reversedURL = nil
            isRecording = true
            recordingStart = Date()
            startRecordingTimer()
        } catch let recError {
            error = "Recorder error: \(recError.localizedDescription)"
        }
    }

    func stopRecording() {
        recorder?.stop()
        recorder = nil
        stopRecordingTimer()
        isRecording = false
        // Reverse after a brief moment for the file to flush
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.reverseAudio()
        }
    }

    private func startRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let start = self.recordingStart else { return }
            self.recordingDuration = Date().timeIntervalSince(start)
        }
    }

    private func stopRecordingTimer() {
        recordingTimer?.invalidate()
        recordingTimer = nil
    }

    // MARK: - Reversal

    /// R6-1: Reverse audio by reading PCM samples and flipping them
    private func reverseAudio() {
        guard let inputURL = originalURL else { return }

        do {
            let inputFile = try AVAudioFile(forReading: inputURL)
            let format = inputFile.processingFormat
            let frameCount = AVAudioFrameCount(inputFile.length)
            guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
                error = "Failed to create PCM buffer"
                return
            }
            try inputFile.read(into: buffer)

            // Reverse samples in-place
            if let channelData = buffer.floatChannelData {
                let channelCount = Int(buffer.format.channelCount)
                let frameLength = Int(buffer.frameLength)
                for ch in 0..<channelCount {
                    let samples = channelData[ch]
                    var i = 0
                    var j = frameLength - 1
                    while i < j {
                        let tmp = samples[i]
                        samples[i] = samples[j]
                        samples[j] = tmp
                        i += 1
                        j -= 1
                    }
                }
            } else if let channelData = buffer.int16ChannelData {
                // Fallback: int16 samples
                let channelCount = Int(buffer.format.channelCount)
                let frameLength = Int(buffer.frameLength)
                for ch in 0..<channelCount {
                    let samples = channelData[ch]
                    var i = 0
                    var j = frameLength - 1
                    while i < j {
                        let tmp = samples[i]
                        samples[i] = samples[j]
                        samples[j] = tmp
                        i += 1
                        j -= 1
                    }
                }
            }

            // Write reversed to new file
            let outputURL = inputURL.deletingPathExtension()
                .appendingPathExtension("reversed.caf")
            let outputFile = try AVAudioFile(forWriting: outputURL, settings: inputFile.fileFormat.settings)
            try outputFile.write(from: buffer)

            reversedURL = outputURL
            error = nil
        } catch let revError {
            self.error = "Reversal error: \(revError.localizedDescription)"
        }
    }

    // MARK: - Playback

    func play(reversed: Bool) {
        let url = reversed ? reversedURL : originalURL
        guard let url = url else { return }

        do {
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
            stopCurrentPlayback()
            let p = try AVAudioPlayer(contentsOf: url)
            p.delegate = self
            p.prepareToPlay()
            p.play()
            player = p
            isPlaying = true
            playbackProgress = 0
            startPlaybackTimer()
        } catch let playbackError {
            error = "Playback error: \(playbackError.localizedDescription)"
        }
    }

    func stopPlayback() {
        stopCurrentPlayback()
    }

    private func stopCurrentPlayback() {
        player?.stop()
        player = nil
        isPlaying = false
        playbackProgress = 0
        playbackTimer?.invalidate()
        playbackTimer = nil
    }

    private func startPlaybackTimer() {
        playbackTimer?.invalidate()
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            guard let self = self, let p = self.player else { return }
            self.playbackProgress = p.duration > 0 ? p.currentTime / p.duration : 0
        }
    }

    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            self.stopCurrentPlayback()
        }
    }

    nonisolated func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        // The stopRecording already triggers reversal
    }
}
