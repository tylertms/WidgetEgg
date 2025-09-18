//
//  UserInfoSmall.swift
//  WidgetEgg
//
//  Created by Tyler on 5/13/25.
//

import SwiftUI

struct UserInfoSmall: View {
    let entry: Provider.Entry
    
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 2) {
                    Image("icon_player")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                    
                    Text(entry.backup?.userName ?? "")
                        .lineLimit(1)
                    
                    Spacer(minLength: 5)
                    
                    Image((entry.backup?.game.permitLevel ?? 0) > 0 ? "pro_permit" : "standard_permit")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                }
                
                HStack(spacing: 2) {
                    Image("egg_soul")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                    
                    Text(bigNumberToString(entry.backup?.game.soulEggsD ?? 0))
                    
                    Spacer(minLength: 5)
                    
                    Image("egg_prophecy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                    
                    Text(String(entry.backup?.game.eggsOfProphecy ?? 0))
                }
                .lineLimit(1)
                
                HStack(spacing: 2) {
                    Image("afx_book_of_basan_4")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                    
                    let EB = calculateEB(from: entry.backup)
                    let role = shortenRole(ebToRole(EB))
                    
                    Text(role)
                    
                    Spacer(minLength: 5)
                    
                    Text(bigNumberToString(EB, digits: 4) + "%")
                }
                
                HStack(spacing: 2) {
                    Image("egg_golden")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 14)
                        .padding(2)
                    
                    let ge_earned = entry.backup?.game.goldenEggsEarned ?? 0
                    let ge_spent = entry.backup?.game.goldenEggsSpent ?? 0
                    let ge_balance = bigNumberToString(Double(ge_earned - ge_spent))
                    
                    Text(ge_balance)
                    
                    Spacer(minLength: 0)
                    
                    Image("shell_script")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                    
                    let tx_earned = entry.backup?.game.shellScriptsEarned ?? 0
                    let tx_spent = entry.backup?.game.shellScriptsSpent ?? 0
                    let tx_balance = bigNumberToString(Double(tx_earned - tx_spent))
                    
                    Text(tx_balance)
                }
                .lineLimit(1)
                
                HStack(spacing: 2) {
                    if let homeFarm = entry.backup?.farms.first(where: { $0.farmType == .home }) {
                        Image("icon_home")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 16)
                        
                        Image("egg_" + String(describing: homeFarm.eggType))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 16)
                        
                        Spacer(minLength: 5)
                        
                        Image("chicken")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 16)
                        
                        Text(bigNumberToString(Double(homeFarm.numChickens)))
                    }
                }
                
                HStack(spacing: 2) {
                    if let grade = entry.backup?.contracts.lastCpi.grade.rawValue, grade > 0 {
                        Image(ALL_GRADES[grade])
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 16)
                    }
                    
                    let seasonCxp = bigNumberToString(entry.backup?.contracts.lastCpi.seasonCxp ?? 0)
                    let totalCxp = bigNumberToString(entry.backup?.contracts.lastCpi.totalCxp ?? 0)
                    
                    Text(seasonCxp)
                    
                    Spacer(minLength: 5)
                    
                    Image("icon_leaderboard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                    
                    Text(totalCxp)
                }
                
                HStack(spacing: 2) {
                    Image("afx_ship_chicken_heavy")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 16)
                    
                    let completedCount = entry.backup?.artifactsDb.missionArchive.count ?? 0
                    let missionInfos = entry.backup?.artifactsDb.missionInfos ?? []
                    let exploringCount = missionInfos.filter{ $0.status.rawValue >= Ei_MissionInfo.Status.exploring.rawValue }.count
                    let missionCount = completedCount + exploringCount
                    
                    Text(bigNumberToString(Double(missionCount)))
                    
                    Spacer(minLength: 5)
                    
                    Image("drone")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 18)
                    
                    Text(bigNumberToString(Double(entry.backup?.stats.droneTakedowns ?? 0)))
                }
                
                Spacer(minLength: 0)
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
        }
        .font(.system(size: 14, weight: .medium))
        .padding(15)
    }
}
