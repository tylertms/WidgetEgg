//
//  WidgetEggApp.swift
//  WidgetEgg
//
//  Created by Tyler on 5/2/24.
//

import SwiftUI

@main
struct WidgetEggApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            }
        }
    }
}

