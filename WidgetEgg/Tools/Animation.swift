//
//  Animation.swift
//  WidgetEgg
//
//  Created by Tyler on 9/16/25.
//

import SwiftUI
import ClockHandRotationEffect

extension View {
    func animationMasked(index: Int, count: Int) -> some View {
        let sliceAngle = 360.0 / Double(count)
        let radius: CGFloat = 1000000
        
        return self.mask {
            ZStack {
                let startAngle = Angle(degrees: Double(sliceAngle) * Double(index))
                let endAngle = Angle(degrees: Double(sliceAngle) * Double(index + 1))

                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addArc(center: .zero,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: false)
                    path.closeSubpath()
                }
                .frame(width: 2000000, height: 2000000)
                .offset(x: 1000000, y: 1000000)
                .clockHandRotationEffect(period: -TimeInterval(count * 5))
                .offset(y: 990000)
            }
        }
    }
}
