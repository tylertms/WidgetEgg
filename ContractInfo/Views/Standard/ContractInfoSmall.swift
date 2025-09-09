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
    @AppStorage("ContractInfoSmall.index", store: UserDefaults(suiteName: "group.com.WidgetEgg")) private var contractIndex: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            if let contracts = entry.backup?.contracts.contracts, contracts.count > 0 {
                let contract = contracts[contractIndex % contracts.count]
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
                    }
                }
            } else {
                ContractInfoEmpty(large: false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .font(.system(size: 14, weight: .medium))
        .padding(15)
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
