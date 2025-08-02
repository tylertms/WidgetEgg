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

    @AppStorage("LastActiveMissionsHash", store: UserDefaults(suiteName: "group.com.WidgetEgg"))
    static var lastActiveMissionsHash: Int = 0

    static func scheduleMissionReturnedNotifications(for missions: [Ei_MissionInfo]) async {
        guard shipReturnNotifications else { return }

        for mission in missions {
            let content = UNMutableNotificationContent()
            content.title = "WidgetEgg"
            content.body = "Your " +
                ALL_DURATION_NAMES[mission.durationType.rawValue] + " " +
                ALL_SHIP_NAMES[mission.ship.rawValue] +
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
        _ missions: [Ei_MissionInfo]
    ) async {
        guard forgottenShipNotifications else { return }
        let activeMissions = missions
            .filter { $0.status.rawValue >= Ei_MissionInfo.Status.exploring.rawValue }

        let newHash = missions.map { $0.identifier.hashValue }.sorted().hashValue
        guard newHash != lastActiveMissionsHash else { return }
        lastActiveMissionsHash = newHash

        guard activeMissions.count < 3 else { return }

        let maxFuelTime = getMaxFuelingTimeSeconds(artifactsInfo, activeMissions)
        guard maxFuelTime > 0 else {
            await sendForgottenLaunchNotification()
            return
        }

        let latestLaunch = getLatestShipLaunch(activeMissions)
        let readyDate = latestLaunch.addingTimeInterval(TimeInterval(maxFuelTime))
        if readyDate <= Date() {
            await sendForgottenLaunchNotification()
        }
    }

    private static func sendForgottenLaunchNotification() async {
        let content = UNMutableNotificationContent()
        content.title = "Don't Forget to Launch!"
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
