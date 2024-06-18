//
//  ArtifactInfo.swift
//  WidgetEgg
//
//  Created by Tyler on 6/18/24.
//

let ALL_SHIPS = [
    "afx_ship_chicken_1",
    "afx_ship_chicken_9",
    "afx_ship_chicken_heavy",
    "afx_ship_bcr",
    "afx_ship_millenium_chicken",
    "afx_ship_corellihen_corvette",
    "afx_ship_galeggtica",
    "afx_ship_defihent",
    "afx_ship_voyegger",
    "afx_ship_henerprise",
    "afx_ship_atreggies"
]

let TANK_SIZES: [Int64] = [
    2_000_000_000,
    200_000_000_000,
    10_000_000_000_000,
    100_000_000_000_000,
    200_000_000_000_000,
    300_000_000_000_000,
    400_000_000_000_000,
    500_000_000_000_000,
]

// Eggs output per second
let FUEL_RATES: [Int64] = [
    5_000_000,
    200_000_000,
    3_000_000_000,
    50_000_000_000,
    75_000_000_000,
    100_000_000_000,
    125_000_000_000,
    150_000_000_000,
]

let TOTAL_FUEL_AMOUNTS: [[Int64]] = [
    [  // Chicken One
        2_000_000,
        3_000_000,
        10_000_000,
        100_000,
    ],
    [  // Chicken Nine
        10_000_000,
        15_000_000,
        25_000_000,
    ],
    [  // Chicken Heavy
        100_000_000,
        55_000_000,
        100_000_000,
    ],
    [  // BCR
        300_000_000,
        475_000_000,
        405_000_000,
    ],
    [  // Quintillion Chicken
        6_000_000_000,
        12_000_000_000,
        35_000_000_000,
    ],
    [  // Cornish-Hen Corvette
        17_000_000_000,
        23_000_000_000,
        30, 500_000_000,
    ],
    [  // Galeggtica
        60_000_000_000,
        100_000_000_000,
        151_000_000_000,
    ],
    [  // Defihent
        250_000_000_000,
        400_000_000_000,
        525_000_000_000,
    ],
    [  // Voyegger
        2_000_000_000_000,
        3_000_000_000_000,
        4_100_000_000_000,
    ],
    [  // Henerprise
        4_000_000_000_000,
        9_000_000_000_000,
        10_000_000_000_000,
    ],
    [  // Attregies Henliner
        11_000_000_000_000,
        16_000_000_000_000,
        20_000_000_000_000,
    ],
]

func getShip(for ship: Int) -> String {
    if ship < 0 || ship >= ALL_SHIPS.count {
        return ALL_SHIPS[0]
    }
    
    return ALL_SHIPS[ship]
}

func getTankSize(for level: Int) -> Int64 {
    if level < 0 || level >= TANK_SIZES.count {
        return -1
    }
    
    return TANK_SIZES[level]
}

func getFuelRate(for level: Int) -> Int64 {
    if level < 0 || level >= TANK_SIZES.count {
        return -1
    }
    
    return FUEL_RATES[level]
}

func getFuelAmount(for ship: Int, with duration: Int) -> Int64 {
    if ship < 0 || ship >= TOTAL_FUEL_AMOUNTS.count {
        return -1
    }
    
    let totalFuelAmounts = TOTAL_FUEL_AMOUNTS[ship]
    if duration < 0 || duration >= totalFuelAmounts.count {
        return -1
    }
    
    return totalFuelAmounts[duration]
}
