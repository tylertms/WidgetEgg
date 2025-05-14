//
//  UserInfo.swift
//  UserInfo
//
//  Created by Tyler on 5/13/25.
//

import WidgetKit
import SwiftUI

struct UserInfo: Widget {
    let kind: String = "UserInfo"
    var supportedFamilyList: [WidgetFamily]
    
    init() {
        supportedFamilyList = [.systemSmall]
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            UserInfoEntryView(entry: entry)
        }
        .configurationDisplayName("User Info")
        .description("Displays information about your account.")
        .supportedFamilies(supportedFamilyList)
        .contentMarginsDisabled()
    }
}
