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
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MissionInfoEntryView(entry: entry)
        }
        .configurationDisplayName("Mission Info")
        .description("Displays information about your active ships.")
        .supportedFamilies(supportedFamilyList)
        .contentMarginsDisabled()
    }
}
