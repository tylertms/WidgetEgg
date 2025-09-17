//
//  SubtitleView.swift
//  WidgetEgg
//
//  Created by Tyler on 9/5/25.
//

import SwiftUI

struct SubtitleView: View {
    let large: Bool
    let contract: Ei_LocalContract
    let coopStatus: Ei_ContractCoopStatusResponse
    
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
            
            if large {
                Text("(\(coopStatus.contributors.count)/\(contract.contract.maxCoopSize))")
            }
            
            Spacer(minLength: 0)
            
            Image("b_icon_token")
                .resizable()
                .frame(width: 14, height: 14)
                .padding(.leading, 3)
                .padding(.trailing, -1)
            
            Text(String(Int(contract.contract.minutesPerToken)) + "m")
                .font(.system(size: 13, weight: .medium))
            
            if large, let userContribution = coopStatus.contributors.first(where: { contributor in
                contributor.userID.count == 18 // Valid EID from user that requested status
            }) {
                Image("icon_player")
                    .resizable()
                    .frame(width: 14, height: 14)
                
                Text("\(userContribution.boostTokens)")
                    .font(.system(size: 13, weight: .medium))
            }
        }
    }
}
