import WidgetKit
import SwiftUI

struct MissionInfo: Widget {
    let kind: String = "MissionInfo"
    var supportedFamilyList: [WidgetFamily]
    
    init() {
#if os(iOS)
        supportedFamilyList = [.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular]
        
        let userDefaults = UserDefaults(suiteName: "group.com.WidgetEgg")!
        userDefaults.register(defaults: Defaults.boolDefaults)
#else
        supportedFamilyList = [.accessoryRectangular, .accessoryCircular, .accessoryCorner]
#endif
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(virtue: false)) { entry in
            MissionInfoEntryView(entry: entry)
        }
        .configurationDisplayName("Mission Info")
        .description("Displays information about your active ships.")
        .supportedFamilies(supportedFamilyList)
        .contentMarginsDisabled()
    }
}

struct VirtueMissionInfo: Widget {
    let kind: String = "VirtueMissionInfo"
    var supportedFamilyList: [WidgetFamily]
    
    init() {
#if os(iOS)
        supportedFamilyList = [.systemSmall, .systemMedium, .accessoryCircular, .accessoryRectangular]
        
        let userDefaults = UserDefaults(suiteName: "group.com.WidgetEgg")!
        userDefaults.register(defaults: Defaults.boolDefaults)
#else
        supportedFamilyList = [.accessoryRectangular, .accessoryCircular, .accessoryCorner]
#endif
    }
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(virtue: true)) { entry in
            MissionInfoEntryView(entry: entry)
        }
        .configurationDisplayName("Virtue Mission Info")
        .description("Displays information about your active ships on the Path of Virtue.")
        .supportedFamilies(supportedFamilyList)
        .contentMarginsDisabled()
    }
}
