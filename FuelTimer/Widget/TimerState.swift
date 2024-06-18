//
//  TimerState.swift
//  WidgetEgg
//
//  Created by Tyler on 6/18/24.
//

import SwiftUI
import Combine

class TimerState: ObservableObject, @unchecked Sendable {
    static let shared = TimerState()
    
    @Published var buttonText: String = "start"
    
    @Published var ship: Int = 0
    @Published var duration: Int = 0
    @Published var level: Int = 0
}
