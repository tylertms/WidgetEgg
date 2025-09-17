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
                HStack(spacing: 2) {
                    ForEach(userContribution.farmInfo.equippedArtifacts, id: \.hashValue) { artifact in
                        getImageFromCompleteArtifact(for: artifact)
                    }
                }
                .padding(.top, 2)
            }
        }
    }
    
    @ViewBuilder
    func getImageFromCompleteArtifact(for artifact: Ei_CompleteArtifact) -> some View {
        let tier = artifact.spec.level.rawValue + 1
        let name = getImageFromAfxID(AFX_ID: artifact.spec.name.rawValue)
        let key = "\(name.dropLast())\(tier)"
        
        Image(key)
            .resizable()
            .frame(width: 26, height: 26)
            .background {
                Circle()
                    .foregroundStyle(getColorFromRarity(for: artifact))
                    .frame(width: 20, height: 20)
                    .blur(radius: 4)
            }
            .overlay(alignment: .bottomTrailing) {
                HStack(spacing: 0) {
                    ForEach(artifact.stones.indices, id: \.self) { stoneIndex in
                        let stone = artifact.stones[stoneIndex]
                        let stoneTier = stone.level.rawValue + 2
                        let stoneName = getImageFromAfxID(AFX_ID: stone.name.rawValue)
                        let stoneKey = "\(stoneName.dropLast())\(stoneTier)"
                        
                        Image(stoneKey)
                            .resizable()
                            .frame(width: 9, height: 9)
                            .padding(.leading, -2)
                    }
                }
            }
    }
    
    func getColorFromRarity(for artifact: Ei_CompleteArtifact) -> Color {
        switch artifact.spec.rarity {
        case .common:
                .gray.opacity(0.15)
        case .rare:
                .blue
        case .epic:
                .purple
        case .legendary:
                .yellow
        }
    }
}

