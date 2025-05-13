//
//  FuelList.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/8/24.
//

import Foundation
import SwiftUI

struct FuelList: View {
    @Environment(\.colorScheme) var theme
    @Environment(\.widgetFamily) var family
    
    @AppStorage("UseTankLimits", store: UserDefaults(suiteName: "group.com.MissionInfo")) var useTankLimits: Bool = false
    
    let artifacts: Ei_Backup.Artifacts
    let scale: CGFloat
    
    var body: some View {
        let topFuels: [(index: Int, value: Double)] = artifacts.tankFuels
            .enumerated()
            .filter { $0.element > 0 }
            .sorted { $0.element > $1.element }
            .prefix(4)
            .sorted { $0.offset < $1.offset }
            .map { (index: $0.offset, value: $0.element) }

        HStack {
            VStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    if index < topFuels.count {
                        let eggInfo = topFuels[index]
                        if let egg = Ei_Egg(rawValue: Int(eggInfo.index + 1)), let image = UIImage(named: "egg_" + egg.description) {
                            Image(uiImage: image)
                                .resizable()
                        } else {
                            Image(uiImage: UIImage(named: "egg_unknown") ?? UIImage())
                                .resizable()
                        }
                    } else {
                        Image(uiImage: UIImage(named: "egg_unknown") ?? UIImage())
                            .resizable()
                    }
                }
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, 0.5)
                .frame(maxHeight: .infinity)
            }
            .frame(maxHeight: scale)
            .aspectRatio(contentMode: .fill)
            .padding(.leading, -1)
                                
            VStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    if index < topFuels.count {
                        let eggInfo = topFuels[index]
                        let fuelLimitScale = ((useTankLimits && artifacts.tankLimits[eggInfo.index] > 0) ? artifacts.tankLimits[eggInfo.index] : 1)
                        let fuelLimit = fuelLimitScale * Double(TANK_SIZES[Int(artifacts.tankLevel)])
                        
                        ProgressView(value: eggInfo.value, total: fuelLimit)
                            .progressViewStyle(.linear)
                            .tint(.green)
                            .background(.gray.opacity(0.18))
                            .frame(maxHeight: .infinity)
                    } else {
                        EmptyEggFuel()
                    }
                }
            }
            .dynamicTypeSize(.xxxLarge)
                        
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    if index < topFuels.count {
                        let eggInfo = topFuels[index]
                        Text(bigNumberToString(eggInfo.value))
                            .frame(maxHeight: .infinity)
                    } else {
                        Text(bigNumberToString(0))
                            .frame(maxHeight: .infinity)
                    }

                }
            }
            .minimumScaleFactor(0.2)
        }
        .font(.system(size: 16, weight: .medium))
        .frame(height: CGFloat(scale))
        .frame(maxWidth: .infinity)
    }
}
