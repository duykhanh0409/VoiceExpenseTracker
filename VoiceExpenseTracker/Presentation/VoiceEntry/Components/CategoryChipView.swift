//
//  CategoryChipView.swift
//  VoiceExpenseTracker — Presentation/VoiceEntry/Components

import SwiftUI

struct CategoryChipView: View {
    let icon: String
    let label: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .medium))
            Text(label.uppercased())
                .font(.appChip)
                .tracking(0.8)
        }
        .foregroundColor(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(color.opacity(0.12))
        .clipShape(Capsule())
        .overlay(Capsule().strokeBorder(color.opacity(0.25), lineWidth: 1))
    }
}
