//
//  DependencyContainer.swift
//  VoiceExpenseTracker
//
//  Infrastructure — Composition Root.
//  ONLY place in the app that knows about concrete types.

import Foundation

@MainActor
final class DependencyContainer {

    // MARK: - Shared instances (stateful)
    let expenseRepository: InMemoryExpenseRepository
    let speechService: SpeechServiceProtocol

    // MARK: - Stateless services
    let voiceParser: VoiceParserProtocol

    // MARK: - Init (all dependencies injected)
    init(
        expenseRepository: InMemoryExpenseRepository,
        speechService: SpeechServiceProtocol,
        voiceParser: VoiceParserProtocol
    ) {
        self.expenseRepository = expenseRepository
        self.speechService = speechService
        self.voiceParser = voiceParser
    }

    // MARK: - Production factory
    static func makeDefault() -> DependencyContainer {
        DependencyContainer(
            expenseRepository: InMemoryExpenseRepository(),
            speechService: SFSpeechService(locale: Locale(identifier: "vi-VN")),
            voiceParser: VoiceInputParser()
        )
    }

    // MARK: - Mock factory (Previews + Tests)
    static func makeMock() -> DependencyContainer {
        DependencyContainer(
            expenseRepository: InMemoryExpenseRepository(),
            speechService: MockSpeechService(),
            voiceParser: VoiceInputParser()
        )
    }
}
