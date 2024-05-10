//
//  CustomGauge.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/3/24.
//

import SwiftUI

struct CustomGauge: View {
    @Environment(\.colorScheme) var theme
    @Environment(\.widgetFamily) var family
    
    @AppStorage("TargetIconSmall", store: UserDefaults(suiteName: "group.com.MissionInfo")) var targetIconSmall: Bool = false
    @AppStorage("TargetIconMedium", store: UserDefaults(suiteName: "group.com.MissionInfo")) var targetIconMedium: Bool = true
    
    
    let mission: Ei_MissionInfo
    let scale: CGFloat
    
    
    var body: some View {
        let gaugeValue: CGFloat = min(1, 1 - mission.secondsRemaining / mission.durationSeconds)
        
        ZStack {
            Circle()
                .stroke(lineWidth: 5)
                .foregroundStyle(.gray.opacity(0.18))
            
            Group {
                if let image = fetchImage(ship: mission.ship.rawValue) {
                    Image(uiImage: image)
                        .resizable()

                } else {
                    ProgressView() // Show progress view if image is being fetched
                }
            }
            .padding(8)
            .scaledToFit()
            
            Group {
                Circle()
                    .trim(from: 0.0, to: CGFloat(gaugeValue))
                    .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .rotationEffect(.degrees(90))
                    .opacity(mission.status == .fueling ? 0.4 : 1)
            }
            .foregroundStyle(getMissionColor(mission: mission))
            
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
            
        }
        .frame(width: CGFloat(scale), height: CGFloat(scale))
    }
}
