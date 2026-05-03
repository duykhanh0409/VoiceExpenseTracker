//
//  ExpenseCategory.swift
//  VoiceExpenseTracker
//
//  Domain Layer — NO SwiftUI / UIKit imports

import Foundation

enum ExpenseCategory: String, CaseIterable, Codable, Equatable {
    case beverage  = "Beverage"
    case food      = "Food & Dining"
    case transport = "Transport"
    case shopping  = "Shopping"
    case other     = "Other"

    // SF Symbol name — just a String, safe in Domain
    var icon: String {
        switch self {
        case .beverage:  return "cup.and.saucer.fill"
        case .food:      return "fork.knife"
        case .transport: return "car.fill"
        case .shopping:  return "bag.fill"
        case .other:     return "ellipsis.circle.fill"
        }
    }

    var displayName: String { rawValue }
}
