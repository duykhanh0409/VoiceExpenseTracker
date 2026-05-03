//
//  SettingsView.swift
//  VoiceExpenseTracker
//
//  🟡 HARDCODED UI — Phase 1 shell, no persistence

import SwiftUI

struct SettingsView: View {
    // Local toggle state — not persisted in Phase 1
    @State private var voiceAutoSave = true
    @State private var hapticFeedback = true
    @State private var iCloudSync = false
    @State private var defaultCurrency = "VND"

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerView
                    contentView
                    voiceReadyBanner
                }
                .padding(.bottom, 100)
            }
        }
        .navigationBarHidden(true)
    }

    // MARK: - Header
    private var headerView: some View {
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
                .foregroundColor(.appAccent)
                .font(.system(size: 18))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    // MARK: - Content
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 28) {
            // Title
            VStack(alignment: .leading, spacing: 4) {
                Text("Settings")
                    .font(.appHeadingLarge)
                    .foregroundColor(.appTextPrimary)
                Text("Configure your voice and sync preferences.")
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            // General Preferences
            settingsSection("GENERAL PREFERENCES") {
                toggleRow(
                    icon: "mic.fill",
                    iconColor: .appAccent,
                    title: "Voice Auto-save",
                    subtitle: "Instantly log expenses after speaking",
                    isOn: $voiceAutoSave
                )
                rowDivider()
                toggleRow(
                    icon: "iphone.radiowaves.left.and.right",
                    iconColor: Color(hex: "7B8FF7"),
                    title: "Haptic Feedback",
                    isOn: $hapticFeedback
                )
                rowDivider()
                toggleRow(
                    icon: "icloud.fill",
                    iconColor: Color(hex: "4A9EFF"),
                    title: "iCloud Sync",
                    isOn: $iCloudSync
                )
            }

            // Localization
            settingsSection("LOCALIZATION") {
                navigationRow(
                    icon: "globe",
                    iconColor: Color(hex: "FFB347"),
                    title: "Default Currency",
                    value: defaultCurrency
                )
            }

            // Account
            settingsSection("ACCOUNT") {
                Button {
                    // No-op in Phase 1
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.appError.opacity(0.15))
                                .frame(width: 36, height: 36)
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.appError)
                        }
                        Text("Sign Out")
                            .font(.appBodyMedium)
                            .foregroundColor(.appError)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                }
            }
        }
    }

    // MARK: - Voice Ready Banner
    private var voiceReadyBanner: some View {
        HStack(spacing: 12) {
            Image(systemName: "waveform")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.appAccent)
            Text("Voice system is ready")
                .font(.appBody)
                .foregroundColor(.appTextSecondary)
            Spacer()
            Circle()
                .fill(Color.appAccent)
                .frame(width: 8, height: 8)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }

    // MARK: - Helpers
    private func settingsSection<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.appLabel)
                .foregroundColor(.appTextTertiary)
                .tracking(1.5)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

            VStack(spacing: 0) {
                content()
            }
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 20)
        }
    }

    private func toggleRow(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String? = nil,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(iconColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.appBodyMedium)
                    .foregroundColor(.appTextPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(.appBodySmall)
                        .foregroundColor(.appTextSecondary)
                }
            }

            Spacer()

            Toggle("", isOn: isOn)
                .tint(.appAccent)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    private func navigationRow(
        icon: String,
        iconColor: Color,
        title: String,
        value: String
    ) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(iconColor)
            }

            Text(title)
                .font(.appBodyMedium)
                .foregroundColor(.appTextPrimary)

            Spacer()

            HStack(spacing: 6) {
                Text(value)
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.appTextTertiary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }

    private func rowDivider() -> some View {
        Divider()
            .background(Color.appSeparator)
            .padding(.leading, 66)
    }
}

#Preview {
    SettingsView()
}
