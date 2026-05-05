//
//  PermissionView.swift
//  VoiceExpenseTracker
//
//  🟢 REAL — Onboarding permission request screen

import SwiftUI
import Speech
import AVFoundation

struct PermissionView: View {
    let onGranted: () -> Void

    @State private var isRequesting = false
    @State private var showDeniedAlert = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Icon
                ZStack {
                    Circle()
                        .fill(Color.appAccent.opacity(0.1))
                        .frame(width: 120, height: 120)
                    Circle()
                        .fill(Color.appAccent.opacity(0.06))
                        .frame(width: 160, height: 160)
                    Image(systemName: "mic.fill")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundColor(.appAccent)
                }
                .padding(.bottom, 36)

                // Title + subtitle
                VStack(spacing: 12) {
                    Text("Voice Access Required")
                        .font(.appHeadingLarge)
                        .foregroundColor(.appTextPrimary)
                        .multilineTextAlignment(.center)

                    Text("SpendVoice cần quyền truy cập micro và nhận diện giọng nói để ghi chi tiêu bằng giọng nói.")
                        .font(.appBody)
                        .foregroundColor(.appTextSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(.bottom, 44)

                // Permission items
                VStack(spacing: 14) {
                    permissionItem(
                        icon: "mic.fill",
                        color: .appAccent,
                        title: "Microphone",
                        description: "Ghi lại giọng nói của bạn"
                    )
                    permissionItem(
                        icon: "waveform",
                        color: Color(hex: "7B8FF7"),
                        title: "Speech Recognition",
                        description: "Chuyển giọng nói thành văn bản"
                    )
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 48)

                // CTA Button
                Button {
                    Task { await requestPermissions() }
                } label: {
                    ZStack {
                        if isRequesting {
                            ProgressView().tint(.black)
                        } else {
                            Text("Grant Access")
                                .font(.appHeadingSmall)
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 58)
                    .background(
                        LinearGradient(
                            colors: [Color.appAccent, Color.appAccent.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: Color.appAccent.opacity(0.4), radius: 16, y: 6)
                }
                .disabled(isRequesting)
                .padding(.horizontal, 28)

                Spacer()
            }
        }
        .alert("Permission Denied", isPresented: $showDeniedAlert) {
            Button("Open Settings") {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Vui lòng bật quyền Microphone và Speech Recognition trong Settings.")
        }
    }

    // MARK: - Private

    private func requestPermissions() async {
        isRequesting = true
        defer { isRequesting = false }

        let micGranted = await AVAudioApplication.requestRecordPermission()
        guard micGranted else { showDeniedAlert = true; return }

        let speechGranted = await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { status in
                cont.resume(returning: status == .authorized)
            }
        }

        if speechGranted { onGranted() } else { showDeniedAlert = true }
    }

    private func permissionItem(
        icon: String, color: Color, title: String, description: String
    ) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(color)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.appBodyMedium).foregroundColor(.appTextPrimary)
                Text(description).font(.appBodySmall).foregroundColor(.appTextSecondary)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.appAccent.opacity(0.35))
                .font(.system(size: 20))
        }
        .padding(16)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    PermissionView(onGranted: {})
}
