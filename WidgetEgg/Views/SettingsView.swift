//
//  SettingsView.swift
//  WidgetEgg
//
//  Created by Tyler on 5/5/24.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    let suite = UserDefaults(suiteName: "group.com.MissionInfo")
    
    let generalSettings: [BooleanSetting] = [
        BooleanSetting(title: "Home Screen Redirect", subtitle: "Tap home screen widgets to open Egg, Inc.", key: "DeepLinkHome", defaultValue: false),
        BooleanSetting(title: "Lock Screen Redirect", subtitle: "Tap lock screen widgets to open Egg, Inc.", key: "DeepLinkLock", defaultValue: true)
    ]
    
    let smallWidgetSettings: [BooleanSetting] = [
        BooleanSetting(title: "Show Targets", subtitle: "Display the targeted artifact for each mission.", key: "TargetIconSmall", defaultValue: true)
    ]
    
    let mediumWidgetSettings: [BooleanSetting] = [
        BooleanSetting(title: "Absolute Time", subtitle: "Show exact return time rather than countdown timer.", key: "UseAbsoluteTime", defaultValue: true),
        BooleanSetting(title: "Fuel Tank", subtitle: "Show fuel tank levels in the fourth slot.", key: "ShowTankLevels", defaultValue: true),
        BooleanSetting(title: "Fuel Limits", subtitle: "Scale fuel tank levels to your in-game limits.", key: "UseTankLimits", defaultValue: false),
        BooleanSetting(title: "Show Targets", subtitle: "Display the targeted artifact for each mission.", key: "TargetIconMedium", defaultValue: true)
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General")) {
                    ForEach(generalSettings) { setting in
                        ToggleRow(setting, for: suite)
                    }
                }
                
                Section(header: Text("Small Widget")) {
                    ForEach(smallWidgetSettings) { setting in
                        ToggleRow(setting, for: suite)
                    }
                }
                
                Section(header: Text("Medium Widget")) {
                    ForEach(mediumWidgetSettings) { setting in
                        ToggleRow(setting, for: suite)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct BooleanSetting: Identifiable {
    var id: String { key }
    let title: String
    let subtitle: String
    let key: String
    let defaultValue: Bool
}

struct ToggleRow: View {
    let title: String
    let subtitle: String

    @AppStorage private var isOn: Bool

    init(_ setting: BooleanSetting, for store: UserDefaults?) {
        self.title = setting.title
        self.subtitle = setting.subtitle

        _isOn = AppStorage(
            wrappedValue: setting.defaultValue,
            setting.key,
            store: store
        )
    }

    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.body)
                if !subtitle.isEmpty {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
        .onChange(of: isOn) { _ in
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
