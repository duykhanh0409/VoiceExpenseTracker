//
//  MockSpeechService.swift
//  VoiceExpenseTracker
//
//  Data/Mocks — for SwiftUI Previews and Unit Tests

import Observation
import Foundation

@Observable
@MainActor
final class MockSpeechService: SpeechServiceProtocol {

    private(set) var recognitionState: SpeechRecognitionState = .idle
    private(set) var currentTranscript: String = ""

    // Configurable for different test scenarios
    var mockTranscript: String = "coffee 50k"
    var mockDelay: TimeInterval = 1.5
    var shouldFail: Bool = false

    func requestPermission() async -> Bool { true }

    func startRecording() async throws {
        recognitionState = .listening
        currentTranscript = ""

        try await Task.sleep(for: .seconds(mockDelay))

        guard !Task.isCancelled else { return }

        if shouldFail {
            recognitionState = .failed(.noSpeechDetected)
            return
        }

        // Simulate partial results word by word
        let words = mockTranscript.components(separatedBy: " ")
        for word in words {
            currentTranscript += (currentTranscript.isEmpty ? "" : " ") + word
            try await Task.sleep(for: .milliseconds(150))
        }
        recognitionState = .finished(transcript: mockTranscript)
    }

    func stopRecording() {
        let transcript = currentTranscript
        recognitionState = transcript.isEmpty ? .idle : .finished(transcript: transcript)
    }

    func cancelRecording() {
        currentTranscript = ""
        recognitionState = .idle
    }
}
