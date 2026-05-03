//
//  SummaryView.swift
//  VoiceExpenseTracker
//
//  🟡 HARDCODED UI — Phase 1 shell, static mock data

import SwiftUI
import Charts

struct SummaryView: View {
    // MARK: - Mock Data
    private let currentPace: Double = 2_482_500
    private let paceChangePercent: Double = 10.5
    private let thisWeek: Double = 540_200
    private let thisMonth: Double = 1_942_300

    private let weekData: [(day: String, amount: Double, isToday: Bool)] = [
        ("MON", 320_000, false),
        ("TUE", 180_000, false),
        ("WED", 450_000, false),
        ("THU", 540_200, true),
        ("FRI", 0,       false),
        ("SAT", 0,       false),
        ("SUN", 0,       false),
    ]

    private let categoryBreakdown: [(name: String, amount: Double, category: ExpenseCategory)] = [
        ("Coffee & Snacks", 528_500, .beverage),
        ("Transport",       310_000, .transport),
        ("Shopping",        415_800, .shopping),
    ]

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    headerBar
                    paceSummaryCard
                    velocityChartCard
                    topCategoryCard
                    breakdownList
                }
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: "waveform")
                    .foregroundColor(.appAccent)
                    .font(.system(size: 16, weight: .semibold))
                Text("SpendVoice")
                    .font(.appBodyMedium)
                    .foregroundColor(.appTextPrimary)
            }
            Spacer()
            Image(systemName: "gear")
                .foregroundColor(.appTextSecondary)
                .font(.system(size: 16))
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    // MARK: - Pace Summary Card
    private var paceSummaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Current Pace
            VStack(alignment: .leading, spacing: 6) {
                Text("CURRENT PACE")
                    .font(.appLabel)
                    .foregroundColor(.appTextSecondary)
                    .tracking(1.5)

                HStack(alignment: .bottom, spacing: 8) {
                    Text(currentPace.formattedVND)
                        .font(.appAmountLarge)
                        .foregroundColor(.appTextPrimary)

                    HStack(spacing: 3) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 11, weight: .bold))
                        Text("+\(String(format: "%.0f", paceChangePercent))% vs last month")
                            .font(.appChip)
                    }
                    .foregroundColor(.appAccent)
                    .padding(.bottom, 4)
                }
            }

            // Stats Row
            HStack(spacing: 0) {
                statItem(title: "THIS WEEK", value: thisWeek.formattedVND)
                Divider()
                    .frame(height: 36)
                    .background(Color.appSeparator)
                    .padding(.horizontal, 16)
                statItem(title: "THIS MONTH", value: thisMonth.formattedVND)
            }
        }
        .padding(20)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }

    private func statItem(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.appLabel)
                .foregroundColor(.appTextTertiary)
                .tracking(1)
            Text(value)
                .font(.appAmountSmall)
                .foregroundColor(.appAccent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Velocity Chart
    private var velocityChartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Daily Velocity")
                        .font(.appHeadingSmall)
                        .foregroundColor(.appTextPrimary)
                    Text("THIS WEEK")
                        .font(.appLabel)
                        .foregroundColor(.appTextTertiary)
                        .tracking(1)
                }
                Spacer()
            }

            Chart {
                ForEach(weekData, id: \.day) { item in
                    BarMark(
                        x: .value("Day", item.day),
                        y: .value("Amount", item.amount)
                    )
                    .foregroundStyle(
                        item.isToday
                            ? Color.appAccent
                            : Color.appAccent.opacity(0.25)
                    )
                    .cornerRadius(6)
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    AxisValueLabel {
                        if let day = value.as(String.self) {
                            Text(day)
                                .font(.appChip)
                                .foregroundColor(.appTextTertiary)
                        }
                    }
                }
            }
            .chartYAxis(.hidden)
            .frame(height: 120)
        }
        .padding(20)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.horizontal, 20)
    }

    // MARK: - Top Category Card
    private var topCategoryCard: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.appAccent.opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: ExpenseCategory.food.icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(.appAccent)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Food & Dining")
                    .font(.appBodyMedium)
                    .foregroundColor(.appTextPrimary)
                Text("54% of total spending")
                    .font(.appBodySmall)
                    .foregroundColor(.appTextSecondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text("844,000đ")
                    .font(.appAmountSmall)
                    .foregroundColor(.appTextPrimary)
                Text("Top category")
                    .font(.appChip)
                    .foregroundColor(.appAccent)
            }
        }
        .padding(16)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color.appAccent.opacity(0.2), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }

    // MARK: - Breakdown
    private var breakdownList: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Breakdown")
                .font(.appHeadingSmall)
                .foregroundColor(.appTextPrimary)
                .padding(.horizontal, 20)

            VStack(spacing: 0) {
                ForEach(Array(categoryBreakdown.enumerated()), id: \.offset) { index, item in
                    HStack(spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(item.category.accentColor.opacity(0.15))
                                .frame(width: 38, height: 38)
                            Image(systemName: item.category.icon)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(item.category.accentColor)
                        }
                        Text(item.name)
                            .font(.appBody)
                            .foregroundColor(.appTextPrimary)
                        Spacer()
                        Text(item.amount.formattedVND)
                            .font(.appBodyMedium)
                            .foregroundColor(.appTextPrimary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                    if index < categoryBreakdown.count - 1 {
                        Divider()
                            .background(Color.appSeparator)
                            .padding(.leading, 68)
                    }
                }
            }
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    SummaryView()
}
