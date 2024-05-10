//
//  MissionInfoEntry.swift
//  WidgetEgg
//
//  Created by Tyler on 5/3/24.
//

import WidgetKit

struct MissionInfoEntry: TimelineEntry {
    let date: Date
    let originalData: [Ei_MissionInfo]
    let missionData: [Ei_MissionInfo]
    let artifactInfo: Ei_Backup.Artifacts?
}
