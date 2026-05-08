//
//  VoiceEntryViewModel.swift
//  VoiceExpenseTracker — Presentation Layer

import Observation
import UIKit

enum VoiceEntryState: Equatable {
    case idle
    case listening
    case processing(transcript: String)
    case success(Expense)
    case error(String)
}

@Observable
@MainActor
final class VoiceEntryViewModel {

    // MARK: - State
    private(set) var entryState: VoiceEntryState = .idle
    var currentTranscript: String = ""

    // MARK: - Dependencies (injected via init — Dependency Inversion)
    private let speechService: SpeechServiceProtocol
    private let saveExpenseUseCase: SaveExpenseUseCaseProtocol

    // MARK: - Private
    private var observationTask: Task<Void, Never>?

    init(
        speechService: SpeechServiceProtocol,
        saveExpenseUseCase: SaveExpenseUseCaseProtocol
    ) {
        self.speechService = speechService
        self.saveExpenseUseCase = saveExpenseUseCase
    }

    // MARK: - Actions

    func startRecording() async {
        guard case .idle = entryState else { return }
        entryState = .listening
        currentTranscript = ""

        do {
            try await speechService.startRecording()
        } catch {
            entryState = .error(error.localizedDescription)
            return
        }

        // Monitor speech service state changes
        observationTask = Task { @MainActor [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                // Sync live transcript
                self.currentTranscript = self.speechService.currentTranscript

                switch self.speechService.recognitionState {
                case .finished(let transcript):
                    self.observationTask = nil
                    await self.processTranscript(transcript)
                    return
                case .failed(let err):
                    self.entryState = .error(err.errorDescription ?? "Recognition failed")
                    self.observationTask = nil
                    return
                default:
                    break
                }
                try? await Task.sleep(for: .milliseconds(80))
            }
        }
    }

    func stopRecording() {
        observationTask?.cancel()
        observationTask = nil
        speechService.stopRecording()
        let transcript = speechService.currentTranscript
        if !transcript.isEmpty {
            Task { await processTranscript(transcript) }
        } else {
            entryState = .idle
        }
    }

    func cancelRecording() {
        observationTask?.cancel()
        observationTask = nil
        speechService.cancelRecording()
        entryState = .idle
        currentTranscript = ""
    }

    func reset() {
        entryState = .idle
        currentTranscript = ""
    }

    // MARK: - Private

    private func processTranscript(_ transcript: String) async {
        entryState = .processing(transcript: transcript)
        do {
            let expense = try await saveExpenseUseCase.execute(from: transcript)
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            entryState = .success(expense)
        } catch {
            entryState = .error(error.localizedDescription)
        }
    }
}
