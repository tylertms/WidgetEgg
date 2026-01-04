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

extension MissionInfoEntry {
    init() {
        self.date = Date(timeIntervalSince1970: 0)
        self.originalData = []
        self.missionData = []
        self.artifactInfo = nil
    }
    
    init(date: Date) {
        self.date = date
        self.originalData = []
        self.missionData = []
        self.artifactInfo = nil
    }
}
