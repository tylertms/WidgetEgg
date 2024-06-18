//
//  TimerSettings.swift
//  WidgetEgg
//
//  Created by Tyler on 6/18/24.
//

import AppIntents
import UIKit

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct TimerSettings: AppIntent {
        
    static var title: LocalizedStringResource = "Open Timer Settings"
    static var description = IntentDescription("Opens the timer settings screen.")
    static var openAppWhenRun: Bool = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

