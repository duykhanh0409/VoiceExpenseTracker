//
//  VoiceExpenseTrackerApp.swift
//  VoiceExpenseTracker
//

import SwiftUI
import Speech
import AVFoundation

@main
struct VoiceExpenseTrackerApp: App {

    // Composition Root — created once, lives for app lifetime
    @State private var container = DependencyContainer.makeDefault()

    // Permission gate — true if both mic + speech are already authorized
    @State private var permissionsGranted = Self.checkPermissions()

    var body: some Scene {
        WindowGroup {
            if permissionsGranted {
                AppTabView()
                    .preferredColorScheme(.dark)
            } else {
                PermissionView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        permissionsGranted = true
                    }
                }
                .preferredColorScheme(.dark)
            }
        }
    }

    // MARK: - Check existing permission status (no prompts)
    private static func checkPermissions() -> Bool {
        let micOK = AVAudioApplication.shared.recordPermission == .granted
        let speechOK = SFSpeechRecognizer.authorizationStatus() == .authorized
        return micOK && speechOK
    }
}

