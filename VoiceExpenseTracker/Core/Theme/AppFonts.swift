//
//  AppFonts.swift
//  VoiceExpenseTracker
//

import SwiftUI

extension Font {
    // MARK: - Amount Display (for currency numbers)
    static let appAmountXL      = Font.system(size: 52, weight: .bold,     design: .rounded)
    static let appAmountLarge   = Font.system(size: 40, weight: .bold,     design: .rounded)
    static let appAmountMedium  = Font.system(size: 28, weight: .bold,     design: .rounded)
    static let appAmountSmall   = Font.system(size: 20, weight: .semibold, design: .rounded)

    // MARK: - Headings
    static let appHeadingLarge  = Font.system(size: 28, weight: .bold)
    static let appHeadingMedium = Font.system(size: 22, weight: .semibold)
    static let appHeadingSmall  = Font.system(size: 18, weight: .semibold)

    // MARK: - Body
    static let appBody          = Font.system(size: 16, weight: .regular)
    static let appBodyMedium    = Font.system(size: 16, weight: .medium)
    static let appBodySmall     = Font.system(size: 14, weight: .regular)

    // MARK: - Caption / Labels
    static let appCaption       = Font.system(size: 12, weight: .medium)
    static let appChip          = Font.system(size: 11, weight: .semibold)
    static let appLabel         = Font.system(size: 10, weight: .bold)
}
