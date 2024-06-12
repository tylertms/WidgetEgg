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
#if os(iOS)
            Image(.wireframe)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50)
#endif
            
            Text("Tap to sign in to WidgetEgg.")
                .multilineTextAlignment(.center)
                .font(.system(size: 16, weight: .semibold))
        }
    }
}
