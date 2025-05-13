//
//  SettingsView.swift
//  WidgetEgg
//
//  Created by Tyler on 5/5/24.
//

import SwiftUI
import WidgetKit

struct SettingsView: View {
    let sharedUserDefaults: UserDefaults? = {
        guard let sharedDefaults = UserDefaults(suiteName: "group.com.MissionInfo") else {
            print("Error: Unable to create shared user defaults suite")
            return nil
        }
        return sharedDefaults
    }()

    @AppStorage("UseAbsoluteTime", store: UserDefaults(suiteName: "group.com.MissionInfo")) var useAbsoluteTime: Bool = false
    @AppStorage("TargetIconSmall", store: UserDefaults(suiteName: "group.com.MissionInfo")) var targetIconSmall: Bool = false
    @AppStorage("ShowTankLevels", store: UserDefaults(suiteName: "group.com.MissionInfo")) var showTankLevels: Bool = false
    @AppStorage("UseTankLimits", store: UserDefaults(suiteName: "group.com.MissionInfo")) var useTankLimits: Bool = true
    @AppStorage("TargetIconMedium", store: UserDefaults(suiteName: "group.com.MissionInfo")) var targetIconMedium: Bool = true
    
    @AppStorage("DeepLinkHome", store: UserDefaults(suiteName: "group.com.MissionInfo")) var deepLinkHome: Bool = true
    @AppStorage("DeepLinkLock", store: UserDefaults(suiteName: "group.com.MissionInfo")) var deepLinkLock: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text("General")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Toggle(isOn: $deepLinkHome, label: {
                        Text("Tap Home screen widgets to open Egg, Inc.")
                            .fontWeight(.medium)
                    })
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    
                    Toggle(isOn: $deepLinkLock, label: {
                        Text("Tap Lock screen widgets to open Egg, Inc.")
                            .fontWeight(.medium)
                    })
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    
                    
                    Text("Small Widget")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    Toggle(isOn: $targetIconSmall, label: {
                        Text("Show targeted artifact")
                            .fontWeight(.medium)
                    })
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    
                    
                    
                    Text("Medium Widget")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top)
                    
                    Toggle(isOn: $useAbsoluteTime, label: {
                        Text("Use absolute time")
                            .fontWeight(.medium)
                    })
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    
                    Toggle(isOn: $showTankLevels, label: {
                        Text("Show fuel tank levels in 4th slot")
                            .fontWeight(.medium)
                    })
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    
                    Toggle(isOn: $useTankLimits, label: {
                        Text("Scale fuel levels to your in-game limits")
                            .fontWeight(.medium)
                    })
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    
                    Toggle(isOn: $targetIconMedium, label: {
                        Text("Show targeted artifact")
                            .fontWeight(.medium)
                    })
                    .padding()
                    .background(Color.gray.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
                    
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Settings")
            
            .onChange(of: useAbsoluteTime) { _ in
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: targetIconSmall) { _ in
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: targetIconMedium) { _ in
                WidgetCenter.shared.reloadAllTimelines()
            }
            .onChange(of: showTankLevels) { _ in
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}
