//
//  MissionInfoEntrySmall.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/3/24.
//

import SwiftUI

struct MissionInfoSmall: View {
    let entry: Provider.Entry
    
    var body: some View {
        GeometryReader { proxy in
            let scale: CGFloat = proxy.size.width * 0.45
            VStack(spacing: CGFloat(scale)/4) {
                ForEach(0..<2) { row in
                    HStack(spacing: CGFloat(scale)/4) {
                        ForEach(0..<2) { column in
                            let index = row * 2 + column
                            if index < entry.missionData.count {
                                CustomGauge(mission: entry.missionData[index], scale: Double(scale))
                            } else {
                                MissionInfoEmptySmall(scale: scale)
                            }
                        }
                    }
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
        .font(.system(size: 20, weight: .medium))
        .padding(15)
    }
}

