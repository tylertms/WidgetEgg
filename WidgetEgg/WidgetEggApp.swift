//
//  WidgetEggApp.swift
//  WidgetEgg
//
//  Created by Tyler on 5/2/24.
//

import SwiftUI

@main
struct WidgetEggApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @AppStorage("DeepLinkHome", store: UserDefaults(suiteName: "group.com.WidgetEgg")) var deepLinkHome: Bool = false
    @AppStorage("DeepLinkLock", store: UserDefaults(suiteName: "group.com.WidgetEgg")) var deepLinkLock: Bool = false
    
    init() {
        let userDefaults = UserDefaults(suiteName: "group.com.WidgetEgg")!
        userDefaults.register(defaults: Defaults.boolDefaults)
    }
    
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
            
#if os(iOS)
            .onOpenURL(perform: { url in
                if shouldOpenEggInc(widget: url.absoluteString.split(separator: "://").last?.description ?? "") {
                    UIApplication.shared.open(URL(string: "egginc://widget")!)
                }
            })
#endif
            
        }
    }
    
    private func shouldOpenEggInc(widget: String) -> Bool {
        return (deepLinkLock && widget.starts(with: "accessory")) ||
        (deepLinkHome && widget.starts(with: "system"))
    }
}

