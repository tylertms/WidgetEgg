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
    
    let artifacts: Ei_Backup.Artifacts
    let scale: CGFloat
    
    var body: some View {
        let fueledEggs = artifacts.tankFuels
        let indexedArray: ArraySlice<[Double]> = fueledEggs
            .enumerated()
            .map { [Double($0.offset + 1), $0.element] }
            .filter { $0[1] >= 1 }
            .sorted(by: { $0[1] > $1[1] })
            .prefix(4)
        
        HStack {
            VStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    if index < indexedArray.count {
                        let eggInfo = indexedArray[index]
                        if let egg = Ei_Egg(rawValue: Int(eggInfo[0])), let image = UIImage(named: "egg_" + egg.description) {
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
                    if indexedArray.count <= index {
                        EmptyEggFuel()
                    } else {
                        let eggInfo = indexedArray[index]
                        ProgressView(value: eggInfo[1], total: Double(TANK_SIZES[Int(artifacts.tankLevel)]))
                            .progressViewStyle(.linear)
                            .tint(.green)
                            .background(.gray.opacity(0.18))
                            .frame(maxHeight: .infinity)
                    }
                }
            }
            .dynamicTypeSize(.xxxLarge)
                        
            VStack(alignment: .trailing, spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    if index < indexedArray.count {
                        let eggInfo = indexedArray[index]
                        Text(bigNumberToString(eggInfo[1]))
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
