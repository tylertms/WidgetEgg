//
//  FuelTimerSmall.swift
//  WidgetEgg
//
//  Created by Tyler on 6/18/24.
//

import AppIntents
import SwiftUI

struct FuelTimerSmall: View {
    let entry: Provider.Entry
    @ObservedObject var timerState: TimerState = .shared
    let timeRange: ClosedRange<Date>

    init(entry: FuelTimerEntry) {
        let totalFuel = getFuelAmount(for: entry.mission, with: entry.duration)
        let fuelRate = getFuelRate(for: entry.tankLevel)

        self.entry = entry
        self.timeRange = Date()...Date().addingTimeInterval(90)  //TimeInterval(totalFuel / fuelRate))
    }

    var body: some View {
        if #available(iOSApplicationExtension 17.0, *) {
            VStack(alignment: .center) {
                HStack {
                    Button(intent: ModifyShip()) {
                        Image(systemName: "chevron.left")
                    }

                    Image(uiImage: resizeImage(
                        image: UIImage(named: getShip(for: timerState.ship)) ?? UIImage(),
                            targetSize: CGSize(width: 64, height: 64)
                        )
                    )
                    
                    Button(intent: TimerSettings()) {
                        Image(systemName: "chevron.right")
                    }
                }
                /*ProgressView(timerInterval: timeRange, countsDown: false, label: {
                    Text("y")
                }, currentValueLabel: {
                    Text("h")
                })
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.green)
                    .frame(width: 50, height: 50)
                */

            }
        } else {
            Text("you shouldn't be here...")
        }
    }
}
