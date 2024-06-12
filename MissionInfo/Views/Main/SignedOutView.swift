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
    
    let resizedIcon = resizeImage(image: UIImage(named: "wireframe")!, targetSize: CGSize(width: 256, height: 256))
    
    var body: some View {
        VStack(alignment: .center) {
            Image(uiImage: resizedIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 50)
        }
    }
}
