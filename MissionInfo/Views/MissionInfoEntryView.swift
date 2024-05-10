//
//  MissionInfoEntry.swift
//  WidgetEgg
//
//  Created by Tyler on 5/3/24.
//

import SwiftUI

struct MissionInfoEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: Provider.Entry
    
    var body: some View {
        if entry.date == Date(timeIntervalSince1970: 0) {
            SignedOutView()
        } else {
            switch family {
            case .systemSmall:
                MissionInfoEntryViewSmall(entry: entry)
            case .systemMedium:
                MissionInfoEntryViewMedium(entry: entry)
            //case .accessoryRectangular:
            //    MissionInfoEntryViewSmall(entry: entry)
            default:
                EmptyView()
            }
        }
    }
}
