//
//  Double+Currency.swift
//  VoiceExpenseTracker
//

import Foundation

extension Double {

    /// Full format: "50,000đ"
    var formattedVND: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        let formatted = formatter.string(from: NSNumber(value: self)) ?? "\(Int(self))"
        return "\(formatted)đ"
    }

    /// Compact format: "50kđ", "1.5trđ", "500đ"
    var formattedVNDCompact: String {
        if self >= 1_000_000 {
            let millions = self / 1_000_000
            let s = millions == millions.rounded(.down) && millions < 10
                ? String(format: "%.1f", millions)
                : String(format: "%.0f", millions)
            return "\(s)trđ"
        } else if self >= 1_000 {
            let thousands = self / 1_000
            let s = thousands == thousands.rounded(.down)
                ? String(format: "%.0f", thousands)
                : String(format: "%.1f", thousands)
            return "\(s)kđ"
        }
        return formattedVND
    }

    /// Plain number string for display: "50,000"
    var formattedNumber: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(Int(self))"
    }
}
