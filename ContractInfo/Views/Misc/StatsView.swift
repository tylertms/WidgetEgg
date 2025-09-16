//
//  StatsView.swift
//  WidgetEgg
//
//  Created by Tyler on 9/5/25.
//

import SwiftUI

struct StatsView: View {
    let large: Bool
    let contract: Ei_LocalContract
    let gradeSpec: Ei_Contract.GradeSpec
    let coopStatus: Ei_ContractCoopStatusResponse
    
    var body: some View {
        HStack(spacing: 2) {
            if let userContribution = coopStatus.contributors.first(where: { contributor in
                contributor.userID.count == 18 // Valid EID from user that requested status
            }) {
                Image("icon_info")
                    .resizable()
                    .frame(width: 16, height: 16)
                
                Text("\(bigNumberToString(userContribution.contributionRate * 3600))/h")
                    .lineLimit(1)
                    .font(.system(size: 13, weight: .medium))
                    .padding(.leading, 1)
                    .padding(.trailing, 4)
                                
                if large {
                    Image("icon_player")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.leading, 1)
                        .padding(.trailing, -2)
                    
                    Text(bigNumberToString(userContribution.contributionAmount))
                        .padding(.trailing, 4)
                            
                    Image("icon_coop")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(.horizontal, 1)
                    
                    Text(bigNumberToString(coopStatus.totalAmount))
                }
                
                Spacer(minLength: 0)
                
                if (scrollColor() != .clear) {
                    Image("scroll")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(scrollColor())
                        .frame(width: 12, height: 12)
                        .padding(.leading, 2)
                }
                
                Text(completionTime())
                    .lineLimit(1)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(completionSecondsColor())
            }
        }
    }
    
    func scrollColor() -> Color {
        if coopStatus.clearedForExit {
            return .green
        } else if coopStatus.allGoalsAchieved {
            return .yellow
        } else {
            return .clear
        }
    }
    
    func completionSecondsColor() -> Color {
        return completionSeconds() > coopStatus.secondsRemaining ? .yellow : .primary
    }
    
    func completionSeconds() -> Double {
        let allGoalsTarget: Double = gradeSpec.goals.map(\.targetAmount).max() ?? coopStatus.totalAmount
                
        let contributionSum: Double = max(1, coopStatus.contributors.map({$0.contributionRate}).reduce(0, +))
                
        let secondsRemaining: Double = (allGoalsTarget - coopStatus.totalAmount) / contributionSum
                        
        return secondsRemaining
    }
    
    func completionTime() -> String {
        if coopStatus.clearedForExit {
            return ""
        } else if coopStatus.allGoalsAchieved {
            return formatCompactDuration(coopStatus.gracePeriodSecondsRemaining)
        }
        
        let secondsRemaining = completionSeconds()
        
        if secondsRemaining >= 365 * 24 * 60 * 60 {
            return "Forever"
        }
        
        return formatCompactDuration(secondsRemaining)
    }
}
