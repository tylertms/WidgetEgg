//
//  MissionInfoAccessoryCorner.swift
//  WidgetEgg
//
//  Created by Tyler on 6/11/24.
//

import SwiftUI

struct MissionInfoAccessoryCorner : View {
    let entry: Provider.Entry
    
    var body: some View {
        GeometryReader { proxy in
            let earliestMission = entry.missionData.filter { $0.status != .fueling }.sorted { $0.secondsRemaining < $1.secondsRemaining }.first
            let scale: CGFloat = proxy.size.width
            
            Group {
                if let earliestMission {
                    CustomGauge(mission: earliestMission, scale: Double(scale), lineWidth: 5)
                        .onAppear {
                            print(min(1, 1 - earliestMission.secondsRemaining / earliestMission.durationSeconds))
                        }
                } else {
                    MissionInfoEmptySmall(scale: scale)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
        .font(.system(size: 20, weight: .medium))
    }
}
