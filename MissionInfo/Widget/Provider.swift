//
//  Provider.swift
//  WidgetEgg
//
//  Created by Tyler on 5/3/24.
//

import WidgetKit
import UserNotifications

struct Provider: TimelineProvider {
    let virtue: Bool
    
    func missionType() -> Ei_MissionInfo.MissionType {
        return virtue ? Ei_MissionInfo.MissionType.virtue : Ei_MissionInfo.MissionType.standard
    }
    
    func placeholder(in context: Context) -> MissionInfoEntry {
        MissionInfoEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MissionInfoEntry) -> ()) {
        completion(MissionInfoEntry(date: Date()))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MissionInfoEntry>) -> ()) {
        
        guard let defaults = UserDefaults(suiteName: "group.com.WidgetEgg"), let EID = defaults.string(forKey: "EID") else {
            return completion(
                Timeline(
                    entries: [MissionInfoEntry()],
                    policy: .after(Date()))
            )
        }
                
        Task {
            do {
                let data = try await fetchData(EID: EID, virtue: virtue)
                let numRefreshes = 36
                
                var missionData = data.0.filter{ $0.type == missionType() }
                let artifactInfo = data.1
                
                var entries = [MissionInfoEntry(date: Date(), originalData: missionData, missionData: missionData, artifactInfo: artifactInfo)]
                
                let activeMissions = missionData.filter({ $0.secondsRemaining > 0 })
                
                await NotificationManager.scheduleMissionReturnedNotifications(for: activeMissions)
                await NotificationManager.submitForgottenLaunchNotifications(artifactInfo, missionData)
                
                if let minRemaining = activeMissions.compactMap({ $0.secondsRemaining }).min() {
                    let refreshInterval = (minRemaining + 10) / Double(numRefreshes)

                    for i in 1...numRefreshes {
                        for j in 0..<missionData.count {
                            missionData[j].secondsRemaining = max(0, missionData[j].secondsRemaining - refreshInterval)
                        }
                        entries.append(MissionInfoEntry(date: Date().advanced(by: refreshInterval * Double(i)), originalData: entries[0].missionData, missionData: missionData, artifactInfo: artifactInfo))
                    }
                }
                
                let timeline = Timeline(entries: entries, policy: activeMissions.count == 3 ? .atEnd : .after(Date()))
                completion(timeline)
            } catch {
                print("Error fetching data: \(error)")
                completion(
                    Timeline(
                        entries: [MissionInfoEntry()],
                        policy: .after(Date()))
                )
            }
        }
    }
}

