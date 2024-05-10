//
//  UI.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/10/24.
//

import Foundation
import SwiftUI


func getRoundingCircle(progress: CGFloat, scale: CGFloat) -> AnyView {
    let angle = (-progress * 360 - 90) * CGFloat.pi / 180
    return AnyView(
        RoundedRectangle(cornerRadius: 100)
            .offset(x: scale / 2 * cos(angle), y: -scale / 2 * sin(angle))
            .frame(width: 5, height: 5)
    )
}

public func fetchImage(ship: Int? = nil, afx: Int? = nil) -> PlatformImage? {
    var key = ""
    if let ship = ship {
        key = ALL_SHIPS[ship]
    } else if let afx = afx {
        key = getImageFromAfxID(AFX_ID: afx)
    }
    
    return PlatformImage(named: key)
}

func getMissionColor(mission: Ei_MissionInfo) -> Color {
    switch mission.durationType {
    case .tutorial:
        return .white
    case .short:
        return .blue
    case .long:
        return .purple
    case .epic:
        return .orange
    }
}
