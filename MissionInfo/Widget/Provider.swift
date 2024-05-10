//
//  Provider.swift
//  WidgetEgg
//
//  Created by Tyler on 5/3/24.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MissionInfoEntry {
        MissionInfoEntry(date: Date(), originalData: [], missionData: [], artifactInfo: nil) // Provide placeholder data
    }
    
    func getSnapshot(in context: Context, completion: @escaping (MissionInfoEntry) -> ()) {
        completion(MissionInfoEntry(date: Date(), originalData: [], missionData: [], artifactInfo: nil))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MissionInfoEntry>) -> ()) {
        
        guard let defaults = UserDefaults(suiteName: "group.com.MissionInfo"), let EID = defaults.string(forKey: "EID") else {
            return completion(
                Timeline(
                    entries: [MissionInfoEntry(date: Date(timeIntervalSince1970: 0), originalData: [], missionData: [], artifactInfo: nil)],
                    policy: .after(Date()))
            )
        }
        
        Task {
            do {
                var data = try await fetchData(EID: EID)
                let numRefreshes = 36
                var entries = [MissionInfoEntry(date: Date(), originalData: data.0, missionData: data.0, artifactInfo: data.1)]
                
                
                let activeMissions = data.0.filter({ $0.secondsRemaining > 0 })
                if let minRemaining = activeMissions.compactMap({ $0.secondsRemaining }).min() {
                    let refreshInterval = (minRemaining + 10) / Double(numRefreshes)

                    for i in 1...numRefreshes {
                        for j in 0..<data.0.count {
                            data.0[j].secondsRemaining -= refreshInterval
                        }
                        entries.append(MissionInfoEntry(date: Date().advanced(by: refreshInterval * Double(i)), originalData: entries[0].missionData, missionData: data.0, artifactInfo: data.1))
                    }
                }
                
                let timeline = Timeline(entries: entries, policy: activeMissions.count == 3 ? .atEnd : .after(Date()))
                completion(timeline)
            } catch {
                print("Error fetching data: \(error)")
                completion(
                    Timeline(
                        entries: [MissionInfoEntry(date: Date(timeIntervalSince1970: 0), originalData: [], missionData: [], artifactInfo: nil)],
                        policy: .after(Date()))
                )
            }
        }
    }

}

