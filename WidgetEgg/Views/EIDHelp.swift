//
//  ShowEIDHelp.swift
//  WidgetEgg
//
//  Created by Tyler on 5/3/24.
//

import Foundation
import SwiftUI

struct EIDHelpView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Divider()
            
            HStack {
                Text("1.  Open Egg, Inc.")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("2.  Open the Settings menu by pressing this icon:")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                VStack {
                    Image(systemName: "ellipsis")
                    Image(systemName: "ellipsis")
                    Image(systemName: "ellipsis")
                }
                .padding(.trailing, 30)
            }
            
            Divider()
            
            HStack {
                Text("3.  Open the Help menu by pressing this icon:")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                Image(systemName: "questionmark.circle")
                    .padding(.trailing, 30)
            }
            
            Divider()
            
            HStack {
                Text("4.  Select \"Data Loss Issue.\"")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("5.  Copy your EID (EI....) from the subject line.")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("6.  Open WidgetEgg.")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 30)
                
                
                Spacer()
            }
            
            Divider()
            
            HStack {
                Text("7.  Paste your EID into the text box and press \"Submit EID.\"")
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
    EIDHelpView()
}
