//
//  ContractInfoEmpty.swift
//  WidgetEgg
//
//  Created by Tyler on 9/9/25.
//

import SwiftUI
import WidgetKit

struct ContractInfoEmpty: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 16)
                .foregroundStyle(.gray.opacity(0.25))
            
            VStack {
                ForEach(0..<2) { index in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 10)
                        .foregroundStyle(.gray.opacity(0.18))
                }
            }
            .padding(.bottom)
            
            VStack {
                ForEach(0..<3) { index in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 10)
                        .foregroundStyle(.gray.opacity(0.18))
                }
            }
        }
    }
}
