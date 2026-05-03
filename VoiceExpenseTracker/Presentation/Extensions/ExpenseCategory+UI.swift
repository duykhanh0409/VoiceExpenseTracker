//
//  ExpenseCategory+UI.swift
//  VoiceExpenseTracker
//
//  Presentation extension — UI concerns stay OUT of Domain layer

import SwiftUI

extension ExpenseCategory {
    var accentColor: Color {
        switch self {
        case .beverage:  return .appAccent
        case .food:      return Color(hex: "FFB347")
        case .transport: return Color(hex: "7B8FF7")
        case .shopping:  return Color(hex: "FF6B9D")
        case .other:     return .appTextSecondary
        }
    }

    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [accentColor.opacity(0.3), accentColor.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
