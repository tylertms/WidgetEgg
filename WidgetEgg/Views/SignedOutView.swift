//
//  SignedOutView.swift
//  WidgetEgg
//
//  Created by Tyler on 5/3/24.
//

import Foundation
import SwiftUI
import WidgetKit

struct SignedOutView: View {
    let family: WidgetFamily
    let resizedIcon = resizeImage(image: UIImage(named: "Wireframe")!, targetSize: CGSize(width: 128, height: 128))
    
    var body: some View {
        VStack(alignment: .center) {
            Image(uiImage: resizedIcon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: 50)
        }
    }
}
