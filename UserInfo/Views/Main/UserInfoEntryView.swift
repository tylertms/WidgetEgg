//
//  UserInfoEntryView.swift
//  WidgetEgg
//
//  Created by Tyler on 5/13/25.
//

import SwiftUI

struct UserInfoEntryView: View {
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
                        UserInfoSmall(entry: entry)
                        
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
