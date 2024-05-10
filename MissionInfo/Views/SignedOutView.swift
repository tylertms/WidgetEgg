//
//  FetchDataFailed.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/3/24.
//

import Foundation
import SwiftUI

struct SignedOutView: View {
    var body: some View {
        VStack {
            Image(.wireframe)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
            
            Text("Tap to sign in to WidgetEgg.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .semibold))
        }
        .widgetBackground(Color.gray.opacity(0.15))
    }
}
