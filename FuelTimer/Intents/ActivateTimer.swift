//
//  WidgetIntent.swift
//  WidgetEgg
//
//  Created by Tyler on 6/18/24.
//

import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct ActivateTimer: AppIntent {
    
    var timerState: TimerState = .shared
    
    static var title: LocalizedStringResource = "Activate Fuel Timer"
    static var description = IntentDescription("Start visual timer and send notification when complete.")
    
    func perform() async throws -> some IntentResult {
        timerState.buttonText = "pressed"
        return .result()
    }
}
