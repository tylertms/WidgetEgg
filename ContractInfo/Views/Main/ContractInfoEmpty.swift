//
//  ContractInfoEmpty.swift
//  WidgetEgg
//
//  Created by Tyler on 9/9/25.
//

import SwiftUI
import WidgetKit

struct ContractInfoEmpty: View {
    let large: Bool
    
    func lineCount() -> Int {
        return large ? 4 : 2
    }
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 16)
                .foregroundStyle(.gray.opacity(0.25))
            
            VStack {
                ForEach(0..<lineCount(), id: \.self) { index in
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 10)
                        .foregroundStyle(.gray.opacity(0.18))
                }
            }
            .padding(.bottom, large ? 10 : 20)
            
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
