//
//  ContractInfoLarge.swift
//  WidgetEgg
//
//  Created by Tyler on 9/9/25.
//

import SwiftUI

struct ContractInfoLarge: View {
    let entry: Provider.Entry
    
    @State var pageIndex = 0
    
    var body: some View {
        VStack {
            if let contracts = entry.backup?.contracts.contracts, !contracts.isEmpty {
                let pages = (contracts.count + 1) / 2
                VStack {
                    ForEach(0..<2, id: \.self) { (contractIndex: Int) in
                        let index = contractIndex + pageIndex * 2
                        
                        if index < contracts.count {
                            ContractInfoMedium(entry: entry, index: index)
                        } else {
                            ContractInfoEmpty(large: true)
                        }
                        
                        if index.isMultiple(of: 2) {
                            Spacer(minLength: 10)
                        }
                    }
                }
                .font(.system(size: 14, weight: .medium))
            } else {
                ContractInfoEmpty(large: true)
                Spacer(minLength: 10)
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

