//
//  Provider.swift
//  WidgetEgg
//
//  Created by Tyler on 7/5/25.
//

import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ContractInfoEntry {
        ContractInfoEntry(date: Date(), backup: nil, statuses: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (ContractInfoEntry) -> ()) {
        completion(ContractInfoEntry(date: Date(), backup: nil, statuses: []))
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<ContractInfoEntry>) -> ()) {
        print("GETTING TIMELINE")
        guard let defaults = UserDefaults(suiteName: "group.com.WidgetEgg"), let EID = defaults.string(forKey: "EID") else {
            return completion(
                Timeline(
                    entries: [ContractInfoEntry(date: Date(timeIntervalSince1970: 0), backup: nil, statuses: [])],
                    policy: .after(Date()))
            )
        }
        
        Task {
            do {
                let basicRequestInfo = getBasicRequestInfo(EID: EID)
                let backup = try await fetchBackup(basicRequestInfo: basicRequestInfo)
                
                let statuses: [Ei_ContractCoopStatusResponse] =
                try await withThrowingTaskGroup(of: Ei_ContractCoopStatusResponse.self) { group in
                  for contract in backup.contracts.contracts {
                    group.addTask {
                      try await fetchCoop(EID: EID, contract: contract.contract.identifier, coop: contract.coopIdentifier)
                    }
                  }

                  var results: [Ei_ContractCoopStatusResponse] = []
                  for try await status in group {
                    results.append(status)
                  }
                  return results
                }
                
                let timeline = Timeline(entries: [ContractInfoEntry(date: Date(), backup: backup, statuses: statuses)], policy: .after(Date(timeIntervalSinceNow: 20 * 60)))
                completion(timeline)
            } catch {
                print("Error fetching data: \(error)")
                completion(Timeline(entries: [ContractInfoEntry(date: Date(timeIntervalSince1970: 0), backup: nil, statuses: [])], policy: .after(Date(timeIntervalSinceNow: 20 * 60))))
            }
        }
    }

}
