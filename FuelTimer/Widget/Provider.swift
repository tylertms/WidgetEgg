//
//  Provider.swift
//  WidgetEgg
//
//  Created by Tyler on 5/3/24.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> FuelTimerEntry {
        FuelTimerEntry(date: Date(), mission: 0, duration: 0, tankLevel: 7)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (FuelTimerEntry) -> ()) {
        completion(FuelTimerEntry(date: Date(), mission: 0, duration: 0, tankLevel: 7))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<FuelTimerEntry>) -> ()) {
        let timeline = Timeline(entries: [FuelTimerEntry(date: Date(), mission: 7, duration: 2, tankLevel: 7)], policy: .never)
        completion(timeline)
    }
}
