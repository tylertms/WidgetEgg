//
//  ContractInfoSmall.swift
//  WidgetEgg
//
//  Created by Tyler on 9/4/25.
//

import SwiftUI

struct ContractInfoMedium: View {
    let entry: Provider.Entry
    
    func spacing() -> CGFloat {
        return (entry.backup?.contracts.contracts.count ?? 0) > 1 ? 15 : 0
    }
    var body: some View {
        HStack(spacing: spacing()) {
            if let contracts = entry.backup?.contracts.contracts, contracts.count > 0 {
                ForEach(contracts, id: \.hashValue) { contract in
                    if let gradeSpec = getGradeSpec(for: contract),
                       let coopStatus = getCoopStatus(for: contract) {
                        GeometryReader { proxy in
                            VStack(alignment: .leading, spacing: 0) {
                                TitleView(contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus, proxy: proxy)
                                
                                SubtitleView(contract: contract)
                                
                                StatsView(contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus)
                                
                                GoalList(contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus, proxy: proxy)
                                
                                Spacer(minLength: 0)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
            } else {
                ContractInfoEmpty()
            }
            
            Spacer(minLength: 0)
        }
        .font(.system(size: 14, weight: .medium))
        .padding(15)
        .padding(.trailing, -spacing())
    }
    
    func getGradeSpec(for contract: Ei_LocalContract) -> Ei_Contract.GradeSpec? {
        return contract.contract.gradeSpecs.first { spec in
            spec.grade == contract.grade
        }
    }
    
    func getCoopStatus(for contract: Ei_LocalContract) -> Ei_ContractCoopStatusResponse? {
        return entry.statuses.first { status in
            status.contractIdentifier == contract.contract.identifier &&
            status.coopIdentifier == contract.coopIdentifier
        }
    }
}
