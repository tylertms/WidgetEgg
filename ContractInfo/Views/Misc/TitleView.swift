//
//  TitleView.swift
//  WidgetEgg
//
//  Created by Tyler on 9/5/25.
//

import SwiftUI
import Foundation
#if canImport(UIKit)
import UIKit
#endif

struct TitleView: View {
    let contract: Ei_LocalContract
    let gradeSpec: Ei_Contract.GradeSpec
    let coopStatus: Ei_ContractCoopStatusResponse
    let proxy: GeometryProxy
    let customEggIconData: [String: Data]

    var body: some View {
        HStack(spacing: 2) {
            getEggImage(for: contract)
                .frame(width: 18, height: 18)

            Text(contract.contract.name)
                .font(.system(size: 16, weight: .semibold))
                .lineLimit(1)

            Spacer(minLength: 0)

            getGradeImage(for: gradeSpec)
                .frame(width: 18, height: 18)

        }
        .padding(.bottom, 4)
        .frame(alignment: .leading)
    }

    func getGradeImage(for gradeSpec: Ei_Contract.GradeSpec) -> Image {
        return Image(getGradeImageString(grade: gradeSpec.grade))
            .resizable()
    }

    func getEggImage(for contract: Ei_LocalContract) -> Image {
        if contract.contract.egg == .customEgg,
           let data = customEggIconData[contract.contract.customEggID] {
#if canImport(UIKit)
            if let image = UIImage(data: data) {
                return Image(uiImage: image)
                    .resizable()
            }
#endif
        }

        if contract.contract.egg == .customEgg {
            return Image("egg_unknown")
                .resizable()
        }

        let egg = contract.contract.egg
        return Image("egg_" + String(describing: egg))
            .resizable()
    }
}
