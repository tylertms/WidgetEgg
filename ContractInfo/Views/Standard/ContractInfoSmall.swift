//
//  ContractInfoSmall.swift
//  WidgetEgg
//
//  Created by Tyler on 9/4/25.
//

import SwiftUI
import WidgetKit
import AppIntents

struct ContractInfoSmall: View {
    let entry: Provider.Entry
    @State var contractIndex = 0
    
    var body: some View {
        if let contracts = entry.backup?.contracts.contracts, contracts.count > 0 {
            Button {
                contractIndex = (contractIndex + 1) % contracts.count
            } label: {
                VStack(alignment: .leading) {
                    let contract = contracts[contractIndex]
                    if let gradeSpec = getGradeSpec(for: contract),
                       let coopStatus = getCoopStatus(for: contract) {
                        GeometryReader { proxy in
                            VStack(alignment: .leading, spacing: 0) {
                                TitleView(contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus, proxy: proxy)
                                
                                SubtitleView(large: false, contract: contract, coopStatus: coopStatus)
                                
                                StatsView(large: false, contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus)
                                
                                GoalList(contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus, proxy: proxy)
                                
                                Spacer(minLength: 0)
                            }
                        }
                    }
                }
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .font(.system(size: 14, weight: .medium))
        } else {
            ContractInfoEmpty(large: false)
        }
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

