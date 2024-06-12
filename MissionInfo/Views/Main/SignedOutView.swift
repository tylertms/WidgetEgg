//
//  FetchDataFailed.swift
//  MissionInfoExtension
//
//  Created by Tyler on 5/3/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct SignedOutView: View {
    
    let family: WidgetFamily
    
    let resizedIcon = resizeImage(image: UIImage(named: "Wireframe")!, targetSize: CGSize(width: 64, height: 64))
    
    var body: some View {
        VStack(alignment: .center) {
            Image(uiImage: resizedIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 50)
            
            Text(String((Bundle.main.infoDictionary?["LSEnvironment"] as? Dictionary<String, String>)?["KEY"]?.count ?? -1))
                .font(.system(size: 16))
                .foregroundStyle(.white)
        }
    }
}
