//
//  HistoryView.swift
//  VoiceExpenseTracker
//
//  🟡 HARDCODED UI — Phase 1 shell, no real data logic

import SwiftUI

// MARK: - Mock Data
private extension Expense {
    static func mock(_ title: String, _ amount: Double, _ category: ExpenseCategory, daysAgo: Int = 0, hour: Int = 12, minute: Int = 0) -> Expense {
        var components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.day! -= daysAgo
        components.hour = hour
        components.minute = minute
        let date = Calendar.current.date(from: components) ?? Date()
        return Expense(title: title, amount: amount, date: date, category: category)
    }

    static let mockToday: [Expense] = [
        .mock("Coffee",  45_000, .beverage, hour: 9,  minute: 41),
        .mock("Lunch",  105_000, .food,     hour: 12, minute: 30),
    ]

    static let mockYesterday: [Expense] = [
        .mock("Groceries", 320_000, .shopping,  daysAgo: 1, hour: 18, minute: 15),
        .mock("Taxi Ride",  86_000, .transport, daysAgo: 1, hour: 19, minute: 28),
    ]
}

// MARK: - Main View
struct HistoryView: View {
    private let todayTotal: Double = 150_000
    private let dailyLimit: Double = 2_000_000

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    DailyTotalHeaderView(total: todayTotal, limit: dailyLimit)
                        .padding(.bottom, 20)

                    // TODAY
                    sectionHeader("TODAY")
                    ForEach(Expense.mockToday) { expense in
                        ExpenseRowView(expense: expense)
                        rowDivider()
                    }

                    sectionHeader("YESTERDAY")
                        .padding(.top, 8)
                    ForEach(Expense.mockYesterday) { expense in
                        ExpenseRowView(expense: expense)
                        rowDivider()
                    }
                }
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.appLabel)
                .foregroundColor(.appTextTertiary)
                .tracking(1.5)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 8)
    }

    private func rowDivider() -> some View {
        Divider()
            .background(Color.appSeparator)
            .padding(.leading, 72)
    }
}

// MARK: - Daily Total Header
private struct DailyTotalHeaderView: View {
    let total: Double
    let limit: Double

    private var progress: Double { min(total / limit, 1.0) }
    private var percent: Int { Int(progress * 100) }

    var body: some View {
        VStack(spacing: 0) {
            // Top Bar
            HStack {
                // App logo area
                HStack(spacing: 6) {
                    Image(systemName: "waveform")
                        .foregroundColor(.appAccent)
                        .font(.system(size: 16, weight: .semibold))
                    Text("SpendVoice")
                        .font(.appBodyMedium)
                        .foregroundColor(.appTextPrimary)
                }

                Spacer()

                HStack(spacing: 14) {
                    Image(systemName: "slider.horizontal.3")
                        .foregroundColor(.appTextSecondary)
                    Image(systemName: "gear")
                        .foregroundColor(.appTextSecondary)
                }
                .font(.system(size: 16))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            // Total Card
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("TODAY'S TOTAL")
                        .font(.appLabel)
                        .foregroundColor(.appTextSecondary)
                        .tracking(1.5)

                    Text(total.formattedVND)
                        .font(.appAmountLarge)
                        .foregroundColor(.appAccent)
                }

                // Progress bar
                VStack(alignment: .leading, spacing: 6) {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.appSurfaceElevated)
                                .frame(height: 4)
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.appAccent)
                                .frame(width: geo.size.width * progress, height: 4)
                                .animation(.easeInOut(duration: 0.8), value: progress)
                        }
                    }
                    .frame(height: 4)

                    Text("\(percent)% OF DAILY LIMIT")
                        .font(.appChip)
                        .foregroundColor(.appTextTertiary)
                        .tracking(0.8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)

            Divider()
                .background(Color.appSeparator)
        }
    }
}

// MARK: - Expense Row
private struct ExpenseRowView: View {
    let expense: Expense

    var body: some View {
        HStack(spacing: 14) {
            // Category icon
            ZStack {
                Circle()
                    .fill(expense.category.accentColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Image(systemName: expense.category.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(expense.category.accentColor)
            }

            // Title + time
            VStack(alignment: .leading, spacing: 3) {
                Text(expense.title)
                    .font(.appBodyMedium)
                    .foregroundColor(.appTextPrimary)
                Text(expense.timeString)
                    .font(.appBodySmall)
                    .foregroundColor(.appTextSecondary)
            }

            Spacer()

            // Amount
            Text(expense.amount.formattedVND)
                .font(.appAmountSmall)
                .foregroundColor(.appTextPrimary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
}

#Preview {
    HistoryView()
}
