//
//  MockExpenseRepository.swift
//  VoiceExpenseTracker
//
//  Data/Mocks — for SwiftUI Previews and Unit Tests

import Foundation

final class MockExpenseRepository: ExpenseRepositoryProtocol {

    var allExpenses: [Expense] = []
    var shouldThrowOnSave: Bool = false

    func fetchAll() async -> [Expense] {
        allExpenses.sorted { $0.date > $1.date }
    }

    func fetchToday() async -> [Expense] {
        allExpenses.filter { Calendar.current.isDateInToday($0.date) }
    }

    func save(_ expense: Expense) async throws {
        if shouldThrowOnSave { throw VoiceEntryError.audioEngineFailure("Mock save error") }
        allExpenses.append(expense)
    }

    func delete(_ id: UUID) async throws {
        allExpenses.removeAll { $0.id == id }
    }
}
