//
//  FuelTimerEntryView.swift
//  WidgetEgg
//
//  Created by Tyler on 6/18/24.
//

import SwiftUI

struct FuelTimerEntryView: View {
    @Environment(\.widgetFamily) var family
    let entry: Provider.Entry
    
    var body: some View {
        Group {
            Group {
                switch family {
                    
                case .systemSmall:
                    FuelTimerSmall(entry: entry)
                    
                default:
                    EmptyView()
                }
            }
#if os(iOS)
            .widgetURL(URL(string: "widgetegg://timer/" + family.description))
#endif
        }
        .widgetBackground(Color.gray.opacity(0.15))
    }
}
