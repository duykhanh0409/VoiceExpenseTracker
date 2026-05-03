//
//  VoiceExpenseTrackerApp.swift
//  VoiceExpenseTracker
//

import SwiftUI

@main
struct VoiceExpenseTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .preferredColorScheme(.dark)
        }
    }
}
