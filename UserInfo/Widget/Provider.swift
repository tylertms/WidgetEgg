//
//  Provider.swift
//  WidgetEgg
//
//  Created by Tyler on 5/13/25.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> UserInfoEntry {
        UserInfoEntry(date: Date(), backup: nil)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (UserInfoEntry) -> ()) {
        completion(UserInfoEntry(date: Date(), backup: nil))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<UserInfoEntry>) -> ()) {
        guard let defaults = UserDefaults(suiteName: "group.com.WidgetEgg"), let EID = defaults.string(forKey: "EID") else {
            return completion(
                Timeline(
                    entries: [UserInfoEntry(date: Date(timeIntervalSince1970: 0), backup: nil)],
                    policy: .after(Date()))
            )
        }
        
        Task {
            do {
                let basicRequestInfo = getBasicRequestInfo(EID: EID)
                let backup = try await fetchBackup(basicRequestInfo: basicRequestInfo)
                let timeline = Timeline(entries: [UserInfoEntry(date: Date(), backup: backup)], policy: .after(Date(timeIntervalSinceNow: 20 * 60)))
                completion(timeline)
            } catch {
                print("Error fetching data: \(error)")
                completion(Timeline(entries: [UserInfoEntry(date: Date(timeIntervalSince1970: 0), backup: nil)], policy: .after(Date(timeIntervalSinceNow: 20 * 60))))
            }
        }
    }

}

