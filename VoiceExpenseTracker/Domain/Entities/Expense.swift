//
//  Expense.swift
//  VoiceExpenseTracker
//
//  Domain Layer — NO SwiftUI / UIKit imports

import Foundation

struct Expense: Identifiable, Equatable, Codable {
    let id: UUID
    let title: String
    let amount: Double
    let date: Date
    let category: ExpenseCategory

    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        date: Date = Date(),
        category: ExpenseCategory = .other
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.category = category
    }
}

// MARK: - Helpers (pure logic, no UI)
extension Expense {
    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(date)
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
