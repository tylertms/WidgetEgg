//
//  GaugeByIndex.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/10/24.
//

import Foundation
import SwiftUI

struct MediumGauge: View {
    
    @AppStorage("UseAbsoluteTime", store: UserDefaults(suiteName: "group.com.MissionInfo")) var useAbsoluteTime: Bool = false
    
    let entry: Provider.Entry
    let index: Int
    let scale: CGFloat
    let missions: [Ei_MissionInfo]
    let proxy: GeometryProxy
    
    var body: some View {
        if index < missions.count {
            let mission = missions[index]
            if let originalMission = entry.originalData.first(where: { $0.identifier == mission.identifier }) {
                return AnyView(
                    HStack {
                        CustomGauge(mission: mission, scale: scale)
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: -1) {
                            if mission.status == .fueling {
                                Text(formatSecondsToHMS(seconds: Int(mission.durationSeconds)))
                            } else {
                                if mission.secondsRemaining <= 0 {
                                    if useAbsoluteTime {
                                        Text(Date(timeIntervalSinceNow: mission.secondsRemaining), style: .time)
                                    } else {
                                        Text("0:00")
                                    }
                                } else {
                                    Text(Date(timeIntervalSinceNow: originalMission.secondsRemaining), style: useAbsoluteTime ? .time : .timer)
                                }
                            }
                            
                            HStack {
                                Text(String(mission.level))
                                Text("★")
                                    .foregroundStyle(.yellow)
                                    .padding(.leading, -6)
                            }
                            
                            HStack {
                                Text(String(mission.capacity))
                                
                                Image(.afxChest)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.leading, -5)
                                    .frame(height: 16)
                            }
                        }
                        .multilineTextAlignment(.trailing)
                        .frame(height: scale)
                        
                    }
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 16, weight: .medium))
                )
            } else {
                return AnyView(
                    EmptyMissionInfoMedium(scale: scale)
                        .frame(maxWidth: .infinity)
                )
            }
        } else {
            return AnyView(
                EmptyMissionInfoMedium(scale: scale)
                    .frame(maxWidth: .infinity)
            )
        }
    }
}
