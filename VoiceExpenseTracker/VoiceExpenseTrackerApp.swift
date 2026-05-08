//
//  VoiceExpenseTrackerApp.swift
//  VoiceExpenseTracker

import SwiftUI
import Speech
import AVFoundation

@main
struct VoiceExpenseTrackerApp: App {

    // Composition Root — single instance for app lifetime
    private let container = DependencyContainer.makeDefault()

    @State private var permissionsGranted = Self.checkPermissions()

    var body: some Scene {
        WindowGroup {
            Group {
                if permissionsGranted {
                    AppTabView(container: container)
                } else {
                    PermissionView {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            permissionsGranted = true
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }

    private static func checkPermissions() -> Bool {
        let micOK    = AVAudioApplication.shared.recordPermission == .granted
        let speechOK = SFSpeechRecognizer.authorizationStatus() == .authorized
        return micOK && speechOK
    }
}
