//
//  ExpenseRepositoryProtocol.swift
//  VoiceExpenseTracker
//
//  Domain Layer — Interface Segregation: read & write are separate protocols

import Foundation

// Read-only capability
protocol ExpenseReadable {
    func fetchAll() async -> [Expense]
    func fetchToday() async -> [Expense]
}

// Write capability
protocol ExpenseWritable {
    func save(_ expense: Expense) async throws
    func delete(_ id: UUID) async throws
}

// Combined repository alias
typealias ExpenseRepositoryProtocol = ExpenseReadable & ExpenseWritable
