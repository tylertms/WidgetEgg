//
//  TokenView.swift
//  WidgetEgg
//
//  Created by Tyler on 9/12/25.
//

import SwiftUI

struct ArtifactView: View {
    let coopStatus: Ei_ContractCoopStatusResponse
    
    var body: some View {
        HStack(spacing: 2) {
            if let userContribution = coopStatus.contributors.first(where: { contributor in
                contributor.userID.count == 18 // Valid EID from user that requested status
            }) {
                
            }
        }
    }
}
