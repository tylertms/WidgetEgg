//
//  ContractInfoMedium.swift
//  WidgetEgg
//
//  Created by Tyler on 9/4/25.
//

import SwiftUI
import WidgetKit

struct ContractInfoMedium: View {
    let entry: Provider.Entry
    let index: Int?
    
    init(entry: Provider.Entry, index: Int? = nil) {
        self.entry = entry
        self.index = index
    }
    
    private var large: Bool {
        index != nil
    }
    
    var body: some View {
        
        if let contracts = entry.backup?.contracts.contracts, contracts.count > 0 {
            if let index = index, index < contracts.count {
                getPrimaryView(for: contracts[index])
            } else {
                let pages = (contracts.count + 1) / 2
                ZStack {
                    ForEach(0 ..< pages, id: \.self) { pageIndex in
                        HStack(spacing: 15) {
                            ForEach(0..<2, id: \.self) { contractIndex in
                                let index = contractIndex + pageIndex * 2
                                if index < contracts.count {
                                    getPrimaryView(for: contracts[index])
                                } else if pages > 1 {
                                    ContractInfoEmpty(large: false)
                                }
                            }
                        }
                        .font(.system(size: 14, weight: .medium))
                        .animationMasked(index: pageIndex, count: pages)
                    }
                    
                }
            }
            
        } else {
            ContractInfoEmpty(large: false)
        }
    }
    
    @ViewBuilder
    private func getPrimaryView(for contract: Ei_LocalContract) -> some View {
        if let gradeSpec = getGradeSpec(for: contract),
           let coopStatus = getCoopStatus(for: contract) {
            GeometryReader { proxy in
                VStack(alignment: .leading, spacing: 0) {
                    TitleView(contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus, proxy: proxy)
                    
                    SubtitleView(large: large, contract: contract, coopStatus: coopStatus)
                    
                    StatsView(large: large, contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus)
                    
                    if large {
                        ArtifactView(coopStatus: coopStatus)
                    }
                    
                    GoalList(contract: contract, gradeSpec: gradeSpec, coopStatus: coopStatus, proxy: proxy)
                    
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    private func getGradeSpec(for contract: Ei_LocalContract) -> Ei_Contract.GradeSpec? {
        return contract.contract.gradeSpecs.first { spec in
            spec.grade == contract.grade
        }
    }
    
    private func getCoopStatus(for contract: Ei_LocalContract) -> Ei_ContractCoopStatusResponse? {
        return entry.statuses.first { status in
            status.contractIdentifier == contract.contract.identifier &&
            status.coopIdentifier == contract.coopIdentifier
        }
    }
}
