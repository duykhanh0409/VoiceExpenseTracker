//
//  VoiceEntryView.swift
//  VoiceExpenseTracker
//
//  🟢 PLACEHOLDER — Phase 1 shell only
//  Real implementation happens in Phase 3

import SwiftUI

struct VoiceEntryView: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Top bar
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
                .padding(.vertical, 16)

                Spacer()

                // Center content
                VStack(spacing: 28) {
                    Text("LISTENING NOW")
                        .font(.appLabel)
                        .foregroundColor(.appTextSecondary)
                        .tracking(2)

                    // Placeholder transcript
                    VStack(spacing: 8) {
                        Text("Tap mic to start")
                            .font(.appAmountMedium)
                            .foregroundColor(.appTextPrimary)
                        Text("Voice entry coming in Phase 3")
                            .font(.appBody)
                            .foregroundColor(.appTextSecondary)
                            .italic()
                    }

                    // Placeholder waveform
                    PlaceholderWaveform(isAnimating: isAnimating)
                }

                Spacer()

                // Mic button
                ZStack {
                    // Glow ring
                    Circle()
                        .fill(Color.appAccent.opacity(isAnimating ? 0.12 : 0.06))
                        .frame(width: 110, height: 110)
                        .scaleEffect(isAnimating ? 1.15 : 1.0)
                        .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: isAnimating)

                    // Button
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.appAccent, Color.appAccent.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 76, height: 76)
                        .shadow(color: Color.appAccent.opacity(0.4), radius: 20, x: 0, y: 8)

                    Image(systemName: "mic.fill")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.black)
                }
                .onTapGesture {
                    withAnimation { isAnimating.toggle() }
                }

                Spacer()
                    .frame(height: 50)
            }
        }
        .onAppear { isAnimating = true }
        .onDisappear { isAnimating = false }
    }
}

// MARK: - Placeholder Waveform
private struct PlaceholderWaveform: View {
    let isAnimating: Bool
    @State private var heights: [CGFloat] = Array(repeating: 12, count: 22)

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<22, id: \.self) { index in
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.appAccent.opacity(isAnimating ? 0.7 : 0.2))
                    .frame(width: 4, height: heights[index])
                    .animation(
                        .easeInOut(duration: Double.random(in: 0.4...0.9))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.06),
                        value: heights[index]
                    )
            }
        }
        .frame(height: 60)
        .onAppear {
            if isAnimating { randomizeHeights() }
        }
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                randomizeHeights()
            } else {
                heights = Array(repeating: 12, count: 22)
            }
        }
    }

    private func randomizeHeights() {
        for i in 0..<22 {
            heights[i] = CGFloat.random(in: 8...56)
        }
    }
}

#Preview {
    VoiceEntryView()
}
