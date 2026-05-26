//
//  Provider.swift
//  WidgetEgg
//
//  Created by Tyler on 7/5/25.
//

import WidgetKit
import Foundation

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> ContractInfoEntry {
        ContractInfoEntry(date: Date(), backup: nil, statuses: [], customEggIconData: [:])
    }

    func getSnapshot(in context: Context, completion: @escaping (ContractInfoEntry) -> ()) {
        completion(ContractInfoEntry(date: Date(), backup: nil, statuses: [], customEggIconData: [:]))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<ContractInfoEntry>) -> ()) {
        guard let defaults = UserDefaults(suiteName: "group.com.WidgetEgg"), let EID = defaults.string(forKey: "EID") else {
            return completion(
                Timeline(
                    entries: [ContractInfoEntry(date: Date(timeIntervalSince1970: 0), backup: nil, statuses: [], customEggIconData: [:])],
                    policy: .after(Date()))
            )
        }

        Task {
            do {
                let basicRequestInfo = getBasicRequestInfo(EID: EID)
                let backup = try await fetchBackup(basicRequestInfo: basicRequestInfo)
                let customEggIconData = await fetchCustomEggIconData(basicRequestInfo: basicRequestInfo, backup: backup)

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

                let timeline = Timeline(entries: [ContractInfoEntry(date: Date(), backup: backup, statuses: statuses, customEggIconData: customEggIconData)], policy: .after(Date(timeIntervalSinceNow: 20 * 60)))
                completion(timeline)
            } catch {
                print("Error fetching data: \(error)")
                completion(Timeline(entries: [ContractInfoEntry(date: Date(timeIntervalSince1970: 0), backup: nil, statuses: [], customEggIconData: [:])], policy: .after(Date(timeIntervalSinceNow: 20 * 60))))
            }
        }
    }

    private func fetchCustomEggIconData(basicRequestInfo: Ei_BasicRequestInfo, backup: Ei_Backup) async -> [String: Data] {
        let customEggIDs = Set(backup.contracts.contracts.compactMap { contract in
            let customEggID = contract.contract.customEggID
            return contract.contract.egg == .customEgg && !customEggID.isEmpty ? customEggID : nil
        })

        guard !customEggIDs.isEmpty else {
            return [:]
        }

        var customEggsByID = backup.contracts.customEggInfo.reduce(into: [String: Ei_CustomEgg]()) { result, customEgg in
            result[customEgg.identifier] = customEgg
        }

        let missingIDs = customEggIDs.subtracting(customEggsByID.keys)
        if !missingIDs.isEmpty,
           let periodicals = try? await fetchPeriodicals(basicRequestInfo: basicRequestInfo, backup: backup) {
            for customEgg in periodicals.contracts.customEggs where missingIDs.contains(customEgg.identifier) {
                customEggsByID[customEgg.identifier] = customEgg
            }
        }

        var iconData: [String: Data] = [:]
        await withTaskGroup(of: (String, Data?).self) { group in
            for customEggID in customEggIDs {
                guard let customEgg = customEggsByID[customEggID] else {
                    continue
                }

                group.addTask {
                    return (customEggID, await loadCustomEggIconData(customEgg: customEgg))
                }
            }

            for await (customEggID, data) in group {
                if let data {
                    iconData[customEggID] = data
                }
            }
        }

        return iconData
    }
}

private func loadCustomEggIconData(customEgg: Ei_CustomEgg) async -> Data? {
    guard let url = URL(string: customEgg.icon.url) else {
        return nil
    }

    let filename = customEggIconFilename(for: customEgg)
    let cacheURL = customEggIconCacheDirectory()?.appendingPathComponent(filename)
    if let cacheURL, let cachedData = try? Data(contentsOf: cacheURL) {
        return cachedData
    }

    guard let (data, response) = try? await URLSession.shared.data(from: url),
          (response as? HTTPURLResponse)?.statusCode == 200 else {
        return nil
    }

    if let cacheURL {
        try? FileManager.default.createDirectory(at: cacheURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        try? data.write(to: cacheURL, options: .atomic)
    }

    return data
}

private func customEggIconCacheDirectory() -> URL? {
    FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.WidgetEgg")?
        .appendingPathComponent("CustomEggIcons", isDirectory: true)
}

private func customEggIconFilename(for customEgg: Ei_CustomEgg) -> String {
    let version = customEgg.icon.checksum.isEmpty ? customEgg.icon.name : customEgg.icon.checksum
    return "custom-egg-\(safeFilenameComponent(customEgg.identifier))-\(safeFilenameComponent(version)).png"
}

private func safeFilenameComponent(_ value: String) -> String {
    value.map { character in
        character.isLetter || character.isNumber || character == "-" || character == "_" ? character : "_"
    }.map(String.init).joined()
}
