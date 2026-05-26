//
//  Notifications.swift
//  WidgetEgg
//
//  Created by Tyler on 8/2/25.
//

import SwiftUI
import UserNotifications

struct NotificationManager {
    @AppStorage("ForgottenShipNotifications", store: UserDefaults(suiteName: "group.com.WidgetEgg"))
    static var forgottenShipNotifications: Bool = false

    @AppStorage("ShipReturnNotifications", store: UserDefaults(suiteName: "group.com.WidgetEgg"))
    static var shipReturnNotifications: Bool = false

    private static let fuelingTimeBuffer: Int64 = 10
    private static let userDefaults = UserDefaults(suiteName: "group.com.WidgetEgg") ?? .standard

    static func scheduleMissionReturnedNotifications(for missions: [Ei_MissionInfo]) async {
        guard shipReturnNotifications else { return }

        for mission in missions {
            let content = UNMutableNotificationContent()
            content.title = "WidgetEgg"
            content.body = "Your " +
                (ALL_DURATION_NAMES[safe: mission.durationType.rawValue] ?? "Unknown") + " " +
                (ALL_SHIP_NAMES[safe: mission.ship.rawValue] ?? "ship") +
                " has returned!"
            content.sound = .default
            content.userInfo = ["url": "egginc://widget"]

            let trigger = UNTimeIntervalNotificationTrigger(
                timeInterval: mission.secondsRemaining,
                repeats: false
            )
            let request = UNNotificationRequest(
                identifier: mission.identifier,
                content: content,
                trigger: trigger
            )

            do {
                try await UNUserNotificationCenter.current().add(request)
            } catch {
                print("Error adding notification:", error)
            }
        }
    }

    static func submitForgottenLaunchNotifications(
        _ artifactsInfo: Ei_Backup.Artifacts,
        _ missions: [Ei_MissionInfo],
        missionType: Ei_MissionInfo.MissionType
    ) async {
        guard forgottenShipNotifications else { return }
        let activeMissions = missions
            .filter { $0.status.rawValue >= Ei_MissionInfo.Status.exploring.rawValue }

        let newState = forgottenLaunchState(for: missions)
        let stateKey = forgottenLaunchStateKey(for: missionType)
        guard userDefaults.string(forKey: stateKey) != newState else { return }

        guard activeMissions.count < 3 else { return }

        let maxFuelTime = getMaxFuelingTimeSeconds(artifactsInfo, activeMissions)
        guard maxFuelTime > 0 else {
            userDefaults.set(newState, forKey: stateKey)
            await sendForgottenLaunchNotification()
            return
        }

        let latestLaunch = getLatestShipLaunch(activeMissions)
        let readyDate = latestLaunch.addingTimeInterval(TimeInterval(maxFuelTime + fuelingTimeBuffer))
        if readyDate <= Date() {
            userDefaults.set(newState, forKey: stateKey)
            await sendForgottenLaunchNotification()
        }
    }

    private static func forgottenLaunchStateKey(for missionType: Ei_MissionInfo.MissionType) -> String {
        return "LastForgottenLaunchMissionState.\(missionType.rawValue)"
    }

    private static func forgottenLaunchState(for missions: [Ei_MissionInfo]) -> String {
        let identifiers = missions
            .map(\.identifier)
            .sorted()

        if let data = try? JSONEncoder().encode(identifiers),
           let string = String(data: data, encoding: .utf8) {
            return string
        }

        return identifiers.debugDescription
    }

    private static func sendForgottenLaunchNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "WidgetEgg"
        content.body  = "You have an empty ship slot in Egg, Inc. - Check in and hit launch!"
        content.sound = .default
        content.userInfo = ["url": "egginc://widget"]
        
        let request = UNNotificationRequest(
            identifier: "ForgottenLaunchNotification",
            content: content,
            trigger: nil
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            print("Error adding notification:", error)
        }
    }
}
