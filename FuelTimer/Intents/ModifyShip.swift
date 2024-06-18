//
//  ChangeShip.swift
//  WidgetEgg
//
//  Created by Tyler on 6/18/24.
//

import Foundation
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
struct ModifyShip: AppIntent {

    static var title: LocalizedStringResource = "Modify Ship"
    static var description = IntentDescription("Modify ship type and duration for timer")
    
    @MainActor
    func perform() async throws -> some IntentResult {
        TimerState.shared.ship += 1
        return .result()
    }
}

