//
//  CustomGauge.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/3/24.
//

import SwiftUI
import WidgetKit

struct CustomGauge: View {
    @Environment(\.colorScheme) var theme
    @Environment(\.widgetFamily) var family
    
    @AppStorage("TargetIconSmall", store: UserDefaults(suiteName: "group.com.MissionInfo")) var targetIconSmall: Bool = false
    @AppStorage("TargetIconMedium", store: UserDefaults(suiteName: "group.com.MissionInfo")) var targetIconMedium: Bool = true
    
    let mission: Ei_MissionInfo
    let scale: CGFloat
    let lineWidth: CGFloat
    
    init(mission: Ei_MissionInfo, scale: CGFloat, lineWidth: CGFloat? = nil) {
        self.mission = mission
        self.scale = scale
        self.lineWidth = lineWidth ?? 5.0
    }
    
    var body: some View {
        let gaugeValue: CGFloat = min(1, 1 - CGFloat(mission.secondsRemaining) / CGFloat(mission.durationSeconds))
        
#if os(iOS)
        let smallerResizeFamilies: [WidgetFamily] = [.accessoryRectangular, .accessoryCircular]
#elseif os(watchOS)
        let smallerResizeFamilies: [WidgetFamily] = [.accessoryRectangular, .accessoryCircular, .accessoryCorner]
#endif
        let resizedSize: CGFloat = smallerResizeFamilies.contains(family) ? 64 : 256
        
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(.gray.opacity(0.18))
            
            Group {
                if let image = fetchImage(ship: mission.ship.rawValue) {
                    Image(uiImage: resizeImage(image: image, targetSize: CGSize(width: resizedSize, height: resizedSize)))
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                }
            }
            .padding(8)
            .scaledToFit()
            
            Group {
                Circle()
                    .trim(from: 0.0, to: CGFloat(gaugeValue))
                    .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .opacity(mission.status == .fueling ? 0.4 : 1)
            }
            .foregroundStyle(getMissionColor(mission: mission))
            
#if os(iOS)
            if let targetImage = fetchImage(afx: mission.targetArtifact.rawValue),
               (family == .systemSmall && targetIconSmall || family == .systemMedium && targetIconMedium) {
                Image(uiImage: targetImage)
                    .resizable()
                    .frame(width: scale / 3.5, height: scale / 3.5)
                    .padding(1.5)
                    .background(Color(hue: 0, saturation: 0, brightness: theme == .dark ? 0.18 : (1 - 0.18)))
                    .clipShape(Circle())
                    .offset(x: scale * sqrt(2) / 3.2, y: -scale * sqrt(2) / 4)
            }
#endif
        }
        .frame(width: CGFloat(scale), height: CGFloat(scale))
    }
}
