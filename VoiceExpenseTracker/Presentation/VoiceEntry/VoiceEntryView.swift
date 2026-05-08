//
//  VoiceEntryView.swift
//  VoiceExpenseTracker — Presentation Layer
//
//  🟢 REAL FEATURE — Full voice recording flow

import SwiftUI

struct VoiceEntryView: View {
    @State var viewModel: VoiceEntryViewModel

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            // Main content driven by state
            switch viewModel.entryState {
            case .idle, .listening, .processing:
                recordingScreen
            case .success(let expense):
                VoiceSuccessView(expense: expense) {
                    viewModel.reset()
                }
                .transition(.opacity)
            case .error(let msg):
                errorScreen(msg)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.entryState)
        .onDisappear { viewModel.cancelRecording() }
    }

    // MARK: - Recording Screen

    private var recordingScreen: some View {
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
            VStack(spacing: 20) {
                statusLabel
                transcriptDisplay
                WaveformView(isActive: isListening)
                    .padding(.top, 8)
            }

            Spacer()

            // Mic button
            micButton
                .padding(.bottom, 32)

            // Bottom chips
            bottomChips
                .padding(.bottom, 24)
        }
    }

    // MARK: - Status Label
    private var statusLabel: some View {
        Text(statusText)
            .font(.appLabel)
            .foregroundColor(.appTextSecondary)
            .tracking(2)
            .animation(.none, value: viewModel.entryState)
    }

    private var statusText: String {
        switch viewModel.entryState {
        case .idle:               return "TAP MIC TO START"
        case .listening:          return "LISTENING NOW"
        case .processing:         return "PROCESSING..."
        default:                  return ""
        }
    }

    // MARK: - Transcript Display
    private var transcriptDisplay: some View {
        VStack(spacing: 8) {
            if case .processing(let t) = viewModel.entryState {
                transcriptText(t)
            } else if isListening {
                if viewModel.currentTranscript.isEmpty {
                    Text("Go ahead...")
                        .font(.appHeadingMedium)
                        .foregroundColor(.appTextTertiary)
                        .italic()
                } else {
                    transcriptText(viewModel.currentTranscript)
                }
            } else {
                Text("Voice Expense Tracker")
                    .font(.appAmountMedium)
                    .foregroundColor(.appTextPrimary)
                Text("Say: \"coffee 50k\"")
                    .font(.appBody)
                    .foregroundColor(.appTextSecondary)
                    .italic()
            }
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, 32)
        .frame(minHeight: 90)
    }

    private func transcriptText(_ text: String) -> some View {
        Text(text.capitalized)
            .font(.appAmountMedium)
            .foregroundColor(.appTextPrimary)
            .multilineTextAlignment(.center)
    }

    // MARK: - Mic Button

    private var micButton: some View {
        Button {
            Task {
                if isListening {
                    viewModel.stopRecording()
                } else if case .idle = viewModel.entryState {
                    await viewModel.startRecording()
                }
            }
        } label: {
            ZStack {
                // Glow ring (active state)
                if isListening {
                    Circle()
                        .fill(Color.appAccent.opacity(0.15))
                        .frame(width: 110, height: 110)
                        .scaleEffect(isListening ? 1.1 : 1.0)
                        .animation(
                            .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: isListening
                        )
                }

                // Main circle
                Circle()
                    .fill(
                        LinearGradient(
                            colors: isListening
                                ? [Color.appAccent, Color.appAccent.opacity(0.8)]
                                : [Color.appSurface, Color.appSurfaceElevated],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 76, height: 76)
                    .shadow(
                        color: Color.appAccent.opacity(isListening ? 0.5 : 0.0),
                        radius: 20, y: 8
                    )

                if case .processing = viewModel.entryState {
                    ProgressView().tint(isListening ? .black : .appAccent)
                } else {
                    Image(systemName: isListening ? "stop.fill" : "mic.fill")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundColor(isListening ? .black : .appAccent)
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isListening)
    }

    // MARK: - Bottom Chips

    private var bottomChips: some View {
        HStack(spacing: 12) {
            CategoryChipView(icon: "fork.knife", label: "Dining", color: .appTextSecondary)
            CategoryChipView(icon: "creditcard", label: "Cash", color: .appTextSecondary)
        }
        .opacity(isListening ? 0.5 : 1.0)
    }

    // MARK: - Error Screen

    private func errorScreen(_ message: String) -> some View {
        VStack(spacing: 24) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 52))
                .foregroundColor(.appWarning)

            Text(message)
                .font(.appBodyMedium)
                .foregroundColor(.appTextPrimary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                viewModel.reset()
            } label: {
                Text("Try Again")
                    .font(.appBodyMedium)
                    .foregroundColor(.black)
                    .frame(width: 160, height: 48)
                    .background(Color.appAccent)
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - Helpers

    private var isListening: Bool {
        if case .listening = viewModel.entryState { return true }
        return false
    }
}

#Preview {
    let mock = DependencyContainer.makeMock()
    VoiceEntryView(viewModel: mock.makeVoiceEntryViewModel())
}
