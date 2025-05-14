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


func bigNumberToString(_ number: Double, digits: Int = 3) -> String {
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
    fmt.minimumSignificantDigits = digits
    fmt.maximumSignificantDigits = digits

    return "\(fmt.string(for: num) ?? "NaN")\(unit)"
}

func calculateEB(from backup: Ei_Backup?) -> Double {
    guard let backup = backup else {
        return 0
    }
    
    let peCount = Int(backup.game.eggsOfProphecy)
    let seCount = backup.game.soulEggsD
    
    let peBonusLevel = Int(
        backup.game.epicResearch
            .first { $0.id == "prophecy_bonus" }?
            .level ?? 0
    )
    
    let seBonusLevel = Int(
        backup.game.epicResearch
            .first { $0.id == "soul_eggs" }?
            .level ?? 0
    )
    
    let bonusFactor = Double(peBonusLevel) * 0.01
    let perEgg = (10.0 + Double(seBonusLevel)) * pow(1.05 + bonusFactor, Double(peCount))
    
    return seCount * perEgg
}

func ebToRole(_ eb: Double) -> String {
    return ALL_ROLES[min(Int(log10(max(eb, 1))), ALL_ROLES.count - 1)]
}

func shortenRole(_ role: String) -> String {
    let split = role.split(separator: " ")
    guard split.count == 2 else {
        return "F1"
    }
    
    return split[0].prefix(1) + String(split[1].count)
}
