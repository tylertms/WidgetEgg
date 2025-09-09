//
//  TitleView.swift
//  WidgetEgg
//
//  Created by Tyler on 9/5/25.
//

import SwiftUI

struct TitleView: View {
    let contract: Ei_LocalContract
    let gradeSpec: Ei_Contract.GradeSpec
    let coopStatus: Ei_ContractCoopStatusResponse
    let proxy: GeometryProxy
    
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
    
    func getEggImage(for contract: Ei_LocalContract?) -> Image {
        return Image("egg_" + (contract?.contract.egg.description ?? "unknown"))
            .resizable()
    }
}
