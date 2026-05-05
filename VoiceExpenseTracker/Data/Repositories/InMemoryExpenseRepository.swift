//
//  InMemoryExpenseRepository.swift
//  VoiceExpenseTracker
//
//  Data Layer — implements ExpenseRepositoryProtocol

import Observation
import Foundation

@Observable
final class InMemoryExpenseRepository: ExpenseRepositoryProtocol {

    private(set) var allExpenses: [Expense] = []

    // MARK: - ExpenseReadable

    func fetchAll() async -> [Expense] {
        allExpenses.sorted { $0.date > $1.date }
    }

    func fetchToday() async -> [Expense] {
        allExpenses
            .filter { Calendar.current.isDateInToday($0.date) }
            .sorted { $0.date > $1.date }
    }

    // MARK: - ExpenseWritable

    func save(_ expense: Expense) async throws {
        allExpenses.append(expense)
    }

    func delete(_ id: UUID) async throws {
        allExpenses.removeAll { $0.id == id }
    }
}
