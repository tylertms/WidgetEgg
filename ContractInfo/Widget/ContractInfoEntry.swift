//
//  ContractInfoEntry.swift
//  WidgetEgg
//
//  Created by Tyler on 7/5/25.
//

import WidgetKit
import Foundation

struct ContractInfoEntry: TimelineEntry {
    let date: Date
    let backup: Ei_Backup?
    let statuses: [Ei_ContractCoopStatusResponse]
    let customEggIconData: [String: Data]
}
