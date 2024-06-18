//
//  UI.swift
//  WidgetEgg
//
//  Created by Tyler on 6/18/24.
//

import Foundation
import SwiftUI
import WidgetKit

func getRoundingCircle(progress: CGFloat, scale: CGFloat) -> AnyView {
    let angle = (-progress * 360 - 90) * CGFloat.pi / 180
    return AnyView(
        RoundedRectangle(cornerRadius: 100)
            .offset(x: scale / 2 * cos(angle), y: -scale / 2 * sin(angle))
            .frame(width: 5, height: 5)
    )
}

public func fetchImage(ship: Int? = nil, afx: Int? = nil) -> UIImage? {
    var key = ""
    if let ship = ship {
        key = ALL_SHIPS[ship]
    } else if let afx = afx {
        key = getImageFromAfxID(AFX_ID: afx)
    } else {
        return nil
    }
    
    if key.isEmpty {
        return nil
    }
    
    return UIImage(named: key)
}

func getMissionColor(mission: Ei_MissionInfo, family: WidgetFamily) -> Color {
    
    if family == .accessoryRectangular || family == .accessoryCircular {
#if os(iOS)
        return .white
#endif
    }
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
