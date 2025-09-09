//
//  GoalList.swift
//  WidgetEgg
//
//  Created by Tyler on 9/5/25.
//

import SwiftUI

struct GoalList: View {
    let contract: Ei_LocalContract
    let gradeSpec: Ei_Contract.GradeSpec
    let coopStatus: Ei_ContractCoopStatusResponse
    let proxy: GeometryProxy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(gradeSpec.goals, id: \.hashValue) { goal in
                HStack(spacing: 5) {
                    getCompletionIcon(for: goal)
                    
                    Text(bigNumberToString(goal.targetAmount))
                        .frame(alignment: .leading)
                        .padding(.leading, 2.5)
                    
                    Spacer(minLength: 0)
                    
                    getRewardLabel(for: goal)
                        .frame(alignment: .trailing)
                }
                
                if coopStatus.totalAmount < goal.targetAmount,
                   let goalIndex = gradeSpec.goals.firstIndex(of: goal), (goalIndex == 0 || gradeSpec.goals[goalIndex - 1].targetAmount < coopStatus.totalAmount) {
                    
                    HStack {
                        getCompletionIcon(for: goal)
                            .hidden()
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: (proxy.size.width - 22), height: 8)
                                .opacity(0.2)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .frame(width: max(8, min(coopStatus.totalAmount / goal.targetAmount, 1) * (proxy.size.width - 22)), height: 8)
                                .foregroundStyle(.green)
                            
                            if let userContribution = coopStatus.contributors.first(where: { contributor in
                                contributor.userID.count == 18 // Valid EID from user that requested status
                            }) {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: max(8, min(userContribution.contributionAmount / goal.targetAmount, 1) * (proxy.size.width - 22)), height: 8)
                                    .foregroundStyle(Color(red: 0, green: 133/255, blue: 49/255))
                            }
                        }
                    }
                }
            }
        }
        .frame(width: proxy.size.width)
        .padding(.top, 5)
    }
    
    func getCompletionIcon(for goal: Ei_Contract.Goal) -> some View {
        if (coopStatus.totalAmount >= goal.targetAmount) {
            return AnyView(
                ZStack {
                    Circle()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(.green)
                    
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(.background)
                    
                    Image("icon_check_mark")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 14)
                        .foregroundStyle(.green)
                }
            )
        } else {
            return AnyView(
                ZStack {
                    Circle()
                        .frame(width: 14, height: 14)
                        .foregroundStyle(.green)
                    
                    Image("icon_check_mark")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 14, height: 14)
                        .foregroundStyle(.background)
                }
            )
        }
    }
    
    func getRewardString(for goal: Ei_Contract.Goal) -> String {
        switch goal.rewardType {
        case .artifactCase:
            return "afx_chest"
        case .boost:
            return "b_icon_" + goal.rewardSubType
        case .boostToken:
            return "b_icon_token"
        case .cash:
            return "icon_bock"
        case .chicken:
            return "chicken_box"
        case .eggsOfProphecy:
            return "egg_prophecy"
        case .epicResearchItem:
            return "r_icon_" + goal.rewardSubType
        case .gold:
            return "egg_golden"
        case .piggyFill:
            return "icon_piggy_golden_egg"
        case .piggyLevelBump:
            return "icon_piggy_level_up"
        case .piggyMultiplier:
            return "icon_piggy_level_up"
        case .shellScript:
            return "shell_script"
        case .soulEggs:
            return "egg_soul"
        default:
            return "egg_unknown"
        }
    }
    
    func getRewardLabel(for goal: Ei_Contract.Goal) -> some View {
        let rewardIconString: String = getRewardString(for: goal)
        
        return AnyView(
            HStack(spacing: 4) {
                Image(rewardIconString)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 16)
                
                Text(bigNumberToString(goal.rewardAmount))
                    .font(.system(size: 14, weight: .medium))
            }
                .frame(alignment: .trailing)
        )
    }
}
