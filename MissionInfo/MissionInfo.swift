import WidgetKit
import SwiftUI

struct MissionInfo: Widget {
    let kind: String = "MissionInfo"
    var supportedFamilyList: [WidgetFamily]
    
    init() {
        //if #available(iOSApplicationExtension 16.0, *) {
        //    supportedFamilyList = [.systemSmall, .systemMedium, .accessoryRectangular]
        //} else {
            supportedFamilyList = [.systemSmall, .systemMedium]
        //}
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
