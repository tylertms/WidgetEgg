//
//  SubtitleView.swift
//  WidgetEgg
//
//  Created by Tyler on 9/5/25.
//

import SwiftUI

struct SubtitleView: View {
    let contract: Ei_LocalContract
    
    var body: some View {
        HStack(spacing: 2) {
            Image("icon_coop")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.horizontal, 1)
            
            Text(contract.coopIdentifier)
                .lineLimit(1)
                .font(.system(size: 13, weight: .medium))
                .padding(.leading, 1)
            
            Spacer(minLength: 0)
            
            Image("b_icon_token")
                .resizable()
                .frame(width: 14, height: 14)
                .padding(.leading, 3)
                .padding(.trailing, -1)
            
            Text(String(Int(contract.contract.minutesPerToken)) + "m")
                .font(.system(size: 13, weight: .medium))
        }
    }
}
