//
//  Extensions.swift
//  WidgetEgg
//
//  Created by Tyler on 5/3/24.
//

import SwiftUI
import WidgetKit

#if os(macOS)
public typealias PlatformImage = NSImage
#else
public typealias PlatformImage = UIImage
#endif

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key, value) in self { output += "\(key)=\(value)&" }
        return String(output.dropLast())
    }
}

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOS 17.0, *), #available(macOS 14.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
