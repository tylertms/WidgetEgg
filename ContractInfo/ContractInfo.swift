//
//  ContractInfo.swift
//  ContractInfo
//
//  Created by Tyler on 7/5/25.
//

import WidgetKit
import SwiftUI

struct ContractInfo: Widget {
    let kind: String = "ContractInfo"
    var supportedFamilyList: [WidgetFamily]
    
    init() {
        supportedFamilyList = [.systemSmall, .systemMedium, .systemLarge]
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ContractInfoEntryView(entry: entry)
        }
        .configurationDisplayName("Contract Info")
        .description("Displays information about your active contracts.")
        .supportedFamilies(supportedFamilyList)
        .contentMarginsDisabled()
    }
}
