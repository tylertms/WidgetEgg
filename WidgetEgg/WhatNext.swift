//
//  WhatNext.swift
//  WidgetEgg
//
//  Created by Tyler on 5/7/24.
//

import Foundation
import SwiftUI

struct WhatNextView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            Divider()
            
            HStack {
                Text("1.  Hold down on your home screen to begin editing.")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("2.  Press \"+\" in the upper left and search for \"WidgetEgg.\"")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("3.  Swipe to choose your widget size, then click \"Add Widget.\"")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                Spacer()
                
            }
            
            Divider()
            
            HStack {
                Text("4.  It may take up to 10 minutes for your data to appear in the widget.")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                
                Spacer()
            }
            
            Divider()
            
            Spacer()
        }
    }
}

#Preview {
    WhatNextView()
}
