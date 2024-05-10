//
//  MissionInfoEntryMedium.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/3/24.
//

import SwiftUI

struct MissionInfoEntryViewMedium : View {
    
    @AppStorage("ShowTankLevels", store: UserDefaults(suiteName: "group.com.MissionInfo")) var showTankLevels: Bool = false
    
    let entry: Provider.Entry
    
    var body: some View {
        let missions = entry.missionData
        GeometryReader { proxy in
            let scale = proxy.size.height * 0.45
            
            VStack(spacing: CGFloat(scale)/4) {
                HStack(spacing: CGFloat(scale)/4) {
                    MediumGauge(entry: entry, index: 0, scale: scale, missions: missions, proxy: proxy)
                    MediumGauge(entry: entry, index: 1, scale: scale, missions: missions, proxy: proxy)
                }
                HStack(spacing: CGFloat(scale)/4) {
                    MediumGauge(entry: entry, index: 2, scale: scale, missions: missions, proxy: proxy)
                    
                    if let artifacts = entry.artifactInfo, showTankLevels {
                        FuelList(artifacts: artifacts, scale: scale)
                    } else {
                        MediumGauge(entry: entry, index: 3, scale: scale, missions: missions, proxy: proxy)
                    }
                }
            }
        }
        .font(.system(size: .infinity, weight: .medium))
        .padding(15)
        .widgetBackground(Color.gray.opacity(0.15))
    }
}
