//
//  SaveExpenseUseCase.swift
//  VoiceExpenseTracker — Domain Layer

import Foundation

protocol SaveExpenseUseCaseProtocol {
    func execute(from transcript: String) async throws -> Expense
}

final class SaveExpenseUseCase: SaveExpenseUseCaseProtocol {
    private let repository: ExpenseWritable
    private let parser: VoiceParserProtocol

    init(repository: ExpenseWritable, parser: VoiceParserProtocol) {
        self.repository = repository
        self.parser = parser
    }

    func execute(from transcript: String) async throws -> Expense {
        guard let expense = parser.parse(transcript) else {
            throw VoiceEntryError.parseFailure(transcript)
        }
        try await repository.save(expense)
        return expense
    }
}
