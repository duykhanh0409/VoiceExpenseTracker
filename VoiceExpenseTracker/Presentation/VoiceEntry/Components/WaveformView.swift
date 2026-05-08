//
//  WaveformView.swift
//  VoiceExpenseTracker — Presentation/VoiceEntry/Components

import SwiftUI

struct WaveformView: View {
    let isActive: Bool

    private let barCount = 24
    @State private var heights: [CGFloat] = []
    @State private var timer: Timer?

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<barCount, id: \.self) { i in
                RoundedRectangle(cornerRadius: 3)
                    .fill(
                        LinearGradient(
                            colors: [Color.appAccent, Color.appAccent.opacity(0.5)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(isActive ? 0.85 : 0.2)
                    .frame(width: 4, height: safeHeight(at: i))
                    .animation(.easeInOut(duration: 0.3), value: safeHeight(at: i))
            }
        }
        .frame(height: 64)
        .onAppear { setup() }
        .onDisappear { stopTimer() }
        .onChange(of: isActive) { _, active in
            active ? startTimer() : flattenHeights()
        }
    }

    private func safeHeight(at i: Int) -> CGFloat {
        heights.indices.contains(i) ? heights[i] : 10
    }

    private func setup() {
        heights = Array(repeating: 10, count: barCount)
        if isActive { startTimer() }
    }

    private func startTimer() {
        stopTimer()
        randomize()
        timer = Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { _ in
            randomize()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func randomize() {
        for i in heights.indices {
            heights[i] = CGFloat.random(in: 6...56)
        }
    }

    private func flattenHeights() {
        stopTimer()
        heights = Array(repeating: 10, count: barCount)
    }
}
