//
//  ContractInfoLarge.swift
//  WidgetEgg
//
//  Created by Tyler on 9/9/25.
//

import SwiftUI

struct ContractInfoLarge: View {
    let entry: Provider.Entry
    
    var body: some View {
        VStack {
            if let contracts = entry.backup?.contracts.contracts, !contracts.isEmpty {
                ForEach(0..<2) { index in
                    if index < contracts.count {
                        ContractInfoMedium(entry: entry, large: true)
                    } else {
                        ContractInfoEmpty(large: true)
                    }
                    
                    if index == 0 {
                        Spacer(minLength: 0)
                    }
                }
            } else {
                ContractInfoEmpty(large: true)
                Spacer(minLength: 15)
                ContractInfoEmpty(large: true)
            }
        }
        .font(.system(size: 14, weight: .medium))
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
