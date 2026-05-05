//
//  SFSpeechService.swift
//  VoiceExpenseTracker
//
//  Data Layer — real SFSpeechRecognizer implementation

import Speech
import AVFoundation
import Observation

@Observable
@MainActor
final class SFSpeechService: SpeechServiceProtocol {

    // MARK: - Observable State
    private(set) var recognitionState: SpeechRecognitionState = .idle
    private(set) var currentTranscript: String = ""

    // MARK: - Private
    private let recognizer: SFSpeechRecognizer?
    private var audioEngine = AVAudioEngine()
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // MARK: - Init
    init(locale: Locale = Locale(identifier: "vi-VN")) {
        self.recognizer = SFSpeechRecognizer(locale: locale)
        self.recognizer?.defaultTaskHint = .search
    }

    // MARK: - Permission
    func requestPermission() async -> Bool {
        let micGranted = await AVAudioApplication.requestRecordPermission()
        guard micGranted else { return false }

        return await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { status in
                cont.resume(returning: status == .authorized)
            }
        }
    }

    // MARK: - Recording
    func startRecording() async throws {
        guard let recognizer, recognizer.isAvailable else {
            throw VoiceEntryError.recognitionUnavailable
        }

        // Clean up any previous session
        stopAudioEngine()

        // Configure AVAudioSession
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .duckOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)

        // Create recognition request
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.taskHint = .search
        if recognizer.supportsOnDeviceRecognition {
            request.requiresOnDeviceRecognition = true
        }
        recognitionRequest = request

        // Install mic tap
        let inputNode = audioEngine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()

        recognitionState = .listening
        currentTranscript = ""

        // Handle results (closure runs on arbitrary thread → dispatch to MainActor)
        recognitionTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.handleRecognitionResult(result: result, error: error)
            }
        }
    }

    func stopRecording() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        stopAudioEngine()
        recognitionRequest = nil
        recognitionTask = nil

        // Preserve transcript as finished if we have content
        if !currentTranscript.isEmpty {
            recognitionState = .finished(transcript: currentTranscript)
        } else {
            recognitionState = .idle
        }
    }

    func cancelRecording() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        stopAudioEngine()
        recognitionRequest = nil
        recognitionTask = nil
        currentTranscript = ""
        recognitionState = .idle
    }

    // MARK: - Private Helpers

    private func handleRecognitionResult(result: SFSpeechRecognitionResult?, error: Error?) {
        if let result {
            currentTranscript = result.bestTranscription.formattedString
            if result.isFinal {
                recognitionState = .finished(transcript: currentTranscript)
                stopAudioEngine()
            }
        }

        if let error {
            let nsError = error as NSError
            // NSError code 1110 = no speech input
            if nsError.code == 1110 || nsError.code == 301 {
                recognitionState = currentTranscript.isEmpty
                    ? .failed(.noSpeechDetected)
                    : .finished(transcript: currentTranscript)
            } else if recognitionState == .listening {
                recognitionState = .failed(.audioEngineFailure(error.localizedDescription))
            }
            stopAudioEngine()
        }
    }

    private func stopAudioEngine() {
        guard audioEngine.isRunning else { return }
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}
