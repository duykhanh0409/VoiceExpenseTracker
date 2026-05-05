//
//  SpeechServiceProtocol.swift
//  VoiceExpenseTracker
//
//  Domain Layer — pure Swift

import Foundation

// MARK: - Recognition State
enum SpeechRecognitionState: Equatable {
    case idle
    case listening
    case processing
    case finished(transcript: String)
    case failed(VoiceEntryError)
}

// MARK: - Protocol
@MainActor
protocol SpeechServiceProtocol: AnyObject {
    var recognitionState: SpeechRecognitionState { get }
    var currentTranscript: String { get }

    func requestPermission() async -> Bool
    func startRecording() async throws
    func stopRecording()   // user stops → preserves transcript as .finished
    func cancelRecording() // user cancels → resets to .idle
}
