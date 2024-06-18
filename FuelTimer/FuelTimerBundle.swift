//
//  FuelTimerBundle.swift
//  FuelTimer
//
//  Created by Tyler on 6/18/24.
//

import WidgetKit
import SwiftUI

@main
struct FuelTimerBundle: WidgetBundle {
    var body: some Widget {
        if #available(iOSApplicationExtension 17.0, *) {
            FuelTimer()
        }
    }
}
