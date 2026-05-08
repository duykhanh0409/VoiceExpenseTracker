//
//  DependencyContainer.swift
//  VoiceExpenseTracker — Infrastructure (Composition Root)
//
//  ONLY file that knows concrete types. All other layers depend on protocols.

import Foundation

final class DependencyContainer {

    // MARK: - Shared stateful instances
    let expenseRepository: InMemoryExpenseRepository
    let speechService: SpeechServiceProtocol

    // MARK: - Stateless services
    let voiceParser: VoiceParserProtocol
    let saveExpenseUseCase: SaveExpenseUseCaseProtocol

    // MARK: - Init (all injected)
    init(
        expenseRepository: InMemoryExpenseRepository,
        speechService: SpeechServiceProtocol,
        voiceParser: VoiceParserProtocol,
        saveExpenseUseCase: SaveExpenseUseCaseProtocol
    ) {
        self.expenseRepository = expenseRepository
        self.speechService = speechService
        self.voiceParser = voiceParser
        self.saveExpenseUseCase = saveExpenseUseCase
    }

    // MARK: - Production factory
    static func makeDefault() -> DependencyContainer {
        let repository = InMemoryExpenseRepository()
        let parser     = VoiceInputParser()
        let speech     = SFSpeechService(locale: Locale(identifier: "vi-VN"))
        let saveUseCase = SaveExpenseUseCase(repository: repository, parser: parser)

        return DependencyContainer(
            expenseRepository: repository,
            speechService: speech,
            voiceParser: parser,
            saveExpenseUseCase: saveUseCase
        )
    }

    // MARK: - Mock factory (Previews + Tests)
    static func makeMock() -> DependencyContainer {
        let repository  = InMemoryExpenseRepository()
        let parser      = VoiceInputParser()
        let mockSpeech  = MockSpeechService()
        let saveUseCase = SaveExpenseUseCase(repository: repository, parser: parser)

        return DependencyContainer(
            expenseRepository: repository,
            speechService: mockSpeech,
            voiceParser: parser,
            saveExpenseUseCase: saveUseCase
        )
    }

    // MARK: - ViewModel factories (Phase 3)
    func makeVoiceEntryViewModel() -> VoiceEntryViewModel {
        VoiceEntryViewModel(
            speechService: speechService,
            saveExpenseUseCase: saveExpenseUseCase
        )
    }
}
