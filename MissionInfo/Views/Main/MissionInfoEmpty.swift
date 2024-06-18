//
//  MissionInfoEmpty.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/3/24.
//

import SwiftUI

struct MissionInfoEmptySmall: View {
    let scale: CGFloat
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.5)
            .frame(width: scale, height: scale)
            .foregroundStyle(.gray.opacity(0.18))
    }
}

struct MissionInfoEmptyMedium: View {
    let scale: CGFloat
    var body: some View {
        HStack {
            Circle()
                .stroke(lineWidth: 5.5)
                .frame(width: scale, height: scale)
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Capsule()
                    .frame(width: 60, height: 6)
                Spacer()
                Capsule()
                    .frame(width: 30, height: 6)
                Spacer()
                Capsule()
                    .frame(width: 40, height: 6)
            }
            .multilineTextAlignment(.trailing)
            .padding(.vertical, scale / 8.5)
            .frame(height: scale )
        }
        .foregroundStyle(.gray.opacity(0.18))
    }
}

struct EmptyEggFuel: View {
    var body: some View {
        ProgressView(value: 0, total: 1)
            .progressViewStyle(.linear)
            .tint(.green)
            .background(.gray.opacity(0.18))
            .frame(maxHeight: .infinity)
    }
}
