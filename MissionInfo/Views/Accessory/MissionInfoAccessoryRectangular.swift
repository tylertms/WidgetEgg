//
//  MissionInfoAccessoryRectangular.swift
//  WidgetEgg
//
//  Created by Tyler on 6/11/24.
//

import SwiftUI

struct MissionInfoAccessoryRectangular : View {
    let entry: Provider.Entry
    
    var body: some View {
        GeometryReader { proxy in
            let activeMissions = entry.missionData.filter { $0.status != .fueling }
#if os(iOS)
            let scale: CGFloat = proxy.size.width * 0.375
#elseif os(watchOS)
            let scale: CGFloat = proxy.size.height * 0.9
#endif
            
            HStack(spacing: CGFloat(scale)/4) {
                ForEach(0..<3) { index in
                    if index < activeMissions.count {
                        CustomGauge(mission: activeMissions[index], scale: Double(scale), lineWidth: 4)
                    } else {
                        MissionInfoEmptySmall(scale: scale)
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
        .font(.system(size: 20, weight: .medium))
        .padding(15)
    }
}
