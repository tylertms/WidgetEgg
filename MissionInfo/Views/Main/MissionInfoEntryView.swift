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
        Group {
            if entry.date == Date(timeIntervalSince1970: 0) {
                SignedOutView(family: family)
            } else {
                Group {
                    switch family {
                        
                    case .systemSmall:
                        MissionInfoSmall(entry: entry)
                        
                    case .systemMedium:
                        MissionInfoMedium(entry: entry)
                        
                    case .accessoryRectangular:
                        MissionInfoAccessoryRectangular(entry: entry)
                        
                    case .accessoryCircular:
                        MissionInfoAccessoryCircular(entry: entry)
                        
                    case .accessoryCorner:
                        MissionInfoAccessoryCorner(entry: entry)
                        
                    default:
                        EmptyView()
                    }
                }
#if os(iOS)
                .widgetURL(URL(string: "widgetegg://" + family.description))
#endif
            }
        }
        .widgetBackground(Color.gray.opacity(0.15))
    }
    
}
