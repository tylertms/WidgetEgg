//
//  FuelTimer.swift
//  FuelTimer
//
//  Created by Tyler on 6/18/24.
//

import WidgetKit
import SwiftUI

struct FuelTimer: Widget {
    let kind: String = "FuelTimer"
    var supportedFamilyList: [WidgetFamily]
    
    init() {
#if os(iOS)
        supportedFamilyList = [.systemSmall]
#else
        supportedFamilyList = []
#endif
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FuelTimerEntryView(entry: entry)
        }
        .configurationDisplayName("Fuel Timer")
        .description("Start timers and receive notifications when your ships are done fueling.")
        .supportedFamilies(supportedFamilyList)
        .contentMarginsDisabled()
    }
}
