//
//  VoiceSuccessView.swift
//  VoiceExpenseTracker — Presentation/VoiceSuccess

import SwiftUI

struct VoiceSuccessView: View {
    let expense: Expense
    let onDismiss: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 28) {
                Spacer()

                // Checkmark icon
                ZStack {
                    Circle()
                        .fill(Color.appAccent.opacity(0.08))
                        .frame(width: 140, height: 140)
                    Circle()
                        .fill(Color.appAccent.opacity(0.15))
                        .frame(width: 108, height: 108)
                    Image(systemName: "checkmark")
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.appAccent)
                }
                .scaleEffect(appeared ? 1 : 0.4)
                .opacity(appeared ? 1 : 0)

                // Title + Amount
                VStack(spacing: 10) {
                    Text("Saved: \(expense.title)")
                        .font(.appHeadingMedium)
                        .foregroundColor(.appTextPrimary)

                    HStack(alignment: .bottom, spacing: 4) {
                        Text(expense.amount.formattedNumber)
                            .font(.appAmountLarge)
                            .foregroundColor(.appAccent)
                        Text("đ")
                            .font(.appAmountSmall)
                            .foregroundColor(.appAccent)
                            .padding(.bottom, 6)
                    }
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 12)

                // Chips
                HStack(spacing: 10) {
                    CategoryChipView(
                        icon: expense.category.icon,
                        label: expense.category.displayName,
                        color: expense.category.accentColor
                    )
                    CategoryChipView(
                        icon: "clock",
                        label: "Just Now",
                        color: .appTextSecondary
                    )
                }
                .opacity(appeared ? 1 : 0)

                Text("Transaction logged successfully")
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)
                    .opacity(appeared ? 1 : 0)

                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                appeared = true
            }
            Task {
                try? await Task.sleep(for: .seconds(2))
                onDismiss()
            }
        }
    }
}

#Preview {
    VoiceSuccessView(
        expense: Expense(title: "Coffee", amount: 45_000, category: .beverage),
        onDismiss: {}
    )
}
