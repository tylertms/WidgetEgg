//
//  Numbers.swift
//  WidgetEgg
//
//  Created by Tyler on 5/10/24.
//

import Foundation


func getMissionDuration(mission: Ei_MissionInfo, epicResearch: [Ei_Backup.ResearchItem]) -> Double {
    if let FTL_LEVEL = epicResearch.first(where: { $0.id == "afx_mission_time"})?.level {
        var seconds = Double(SHIP_TIMES[mission.ship.rawValue][mission.durationType.rawValue])
        if mission.ship.rawValue >= Ei_MissionInfo.Spaceship.milleniumChicken.rawValue {
            seconds *= (1 - 0.01 * Double(FTL_LEVEL))
        }
        
        return seconds
    }
    
    return 0
}

func formatSecondsToHMS(seconds: Int) -> String {
    let doubleSeconds = Double(seconds) // Renamed to avoid shadowing
    let hours = Int(doubleSeconds / 3600)
    let minutes = Int((doubleSeconds.truncatingRemainder(dividingBy: 3600)) / 60)
    let remainingSeconds = Int(doubleSeconds.truncatingRemainder(dividingBy: 60)) // Renamed to avoid shadowing
    
    return String(format: "%02d:%02d:%02d", hours, minutes, remainingSeconds)
}


func bigNumberToString(_ number: Double) -> String {
    var num = number
    var unit = ""
    
    if num < 1000 {
        return String(Int(num))
    }
    
    var units = ["k", "M", "B", "T", "Q", "q", "s", "S", "o", "N", "d", "U", "D", "Td", "qd", "Qd", "sd", "Sd", "Od", "Nd", "V", "uV", "dV", "tV", "qV", "QV", "sV", "SV", "OV", "NV", "tT"]
    
    while num >= 1000 {
        num /= 1000
        unit = units.removeFirst()
    }
    
    let fmt = NumberFormatter()
    fmt.numberStyle = .decimal
    fmt.minimumSignificantDigits = 3
    fmt.maximumSignificantDigits = 3

    return "\(fmt.string(for: num) ?? "NaN")\(unit)"
}


/*
 
 func getFuelSecondsRemaining(mission: Ei_MissionInfo, tankLevel: Int) -> Int {
 let totalEggsRequired = getTotalFuel(mission: mission)
 var totalEggsFueled = 0
 
 for fuel in mission.fuel {
 totalEggsFueled += Int(ceil(fuel.amount))
 }
 
 if totalEggsFueled >= totalEggsRequired { return 0 }
 return (totalEggsRequired - totalEggsFueled) / FUEL_RATES[tankLevel]
 }
 
 func getTotalFuel(mission: Ei_MissionInfo) -> Int {
 return TOTAL_FUEL_AMOUNTS[mission.ship.rawValue][mission.durationType.rawValue]
 }
 
 */
