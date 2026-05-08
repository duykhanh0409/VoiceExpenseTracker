//
//  AppTabView.swift
//  VoiceExpenseTracker — Infrastructure

import SwiftUI

struct AppTabView: View {
    let container: DependencyContainer

    @State private var selectedTab: Tab = .voice
    @State private var voiceVM: VoiceEntryViewModel

    enum Tab: Int { case summary, voice, history, settings }

    init(container: DependencyContainer) {
        self.container = container
        _voiceVM = State(initialValue: container.makeVoiceEntryViewModel())
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Screen content
            Group {
                switch selectedTab {
                case .summary:  SummaryView()
                case .voice:    VoiceEntryView(viewModel: voiceVM)
                case .history:  HistoryView()
                case .settings: SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Tab Bar
private struct CustomTabBar: View {
    @Binding var selectedTab: AppTabView.Tab

    var body: some View {
        HStack(spacing: 0) {
            tabItem(icon: "chart.bar.fill", tab: .summary,  label: "Summary")
            Spacer()
            micTabButton
            Spacer()
            tabItem(icon: "clock.fill",    tab: .history,  label: "History")
            tabItem(icon: "gear",          tab: .settings, label: "Settings")
        }
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .padding(.bottom, 28)
        .background(
            ZStack {
                Color.appSurface
                VStack { Divider().background(Color.appSeparator); Spacer() }
            }
            .ignoresSafeArea(edges: .bottom)
        )
    }

    private func tabItem(icon: String, tab: AppTabView.Tab, label: String) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                Text(label)
                    .font(.appChip)
            }
            .foregroundColor(selectedTab == tab ? .appAccent : .appTextTertiary)
            .frame(minWidth: 56)
        }
    }

    private var micTabButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedTab = .voice }
        } label: {
            ZStack {
                Circle()
                    .fill(Color.appAccent.opacity(selectedTab == .voice ? 0.18 : 0.08))
                    .frame(width: 68, height: 68)
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.appAccent, Color.appAccent.opacity(0.75)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 54, height: 54)
                    .shadow(color: Color.appAccent.opacity(0.5), radius: 12, y: 4)
                Image(systemName: "mic.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.black)
            }
        }
        .offset(y: -14)
    }
}

#Preview {
    AppTabView(container: .makeMock())
}
