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

func formatCompactDuration(_ totalSeconds: Double) -> String {
    var seconds = Int(totalSeconds.rounded(.down))  // safely truncate
    
    let days = seconds / 86_400
    seconds %= 86_400
    
    let hours = seconds / 3_600
    seconds %= 3_600
    
    let minutes = seconds / 60
    
    if days > 0 {
        return "\(days)d\(hours)h"
    } else if hours > 0 {
        return "\(hours)h\(minutes)m"
    } else {
        return "\(minutes)m"
    }
}

func bigNumberToString(_ number: Double, digits: Int = 3) -> String {
    var num = number
    var unit = ""
    
    if num < 1000 {
        return String(Int(num))
    }
    
    var units = ["k", "M", "B", "T", "q", "Q", "s", "S", "o", "N", "d", "U", "D", "Td", "qd", "Qd", "sd", "Sd", "Od", "Nd", "V", "uV", "dV", "tV", "qV", "QV", "sV", "SV", "OV", "NV", "tT"]
    
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

func getMaxFuelingTimeSeconds(
  _ artifactsInfo: Ei_Backup.Artifacts,
  _ missions: [Ei_MissionInfo]
) -> Int64 {
    let tankEggsPerSecond = FUEL_RATES[Int(artifactsInfo.tankLevel)]
    guard tankEggsPerSecond > 0 else { return 0 }
    let maxFuelAmount = missions
      .map { TOTAL_FUEL_AMOUNTS[$0.ship.rawValue][$0.durationType.rawValue] }
      .max() ?? 0
    guard maxFuelAmount > 0 else { return 0 }
    return maxFuelAmount / tankEggsPerSecond
}

func getLatestShipLaunch(_ missions: [Ei_MissionInfo]) -> Date {
    return missions
      .map { Date().addingTimeInterval($0.secondsRemaining - $0.durationSeconds) }
      .max()
      ?? Date(timeIntervalSince1970: 0)
}

