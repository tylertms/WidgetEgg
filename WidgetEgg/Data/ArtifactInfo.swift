//
//  ArtifactInfo.swift
//  WidgetEgg
//
//  Created by Tyler on 5/10/24.
//

let MISSION_ENDPOINT = "https://www.auxbrain.com/ei_afx/get_active_missions"
let BACKUP_ENDPOINT = "https://www.auxbrain.com/ei/bot_first_contact"

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
    2000000000,
    200000000000,
    10000000000000,
    100000000000000,
    200000000000000,
    300000000000000,
    400000000000000,
    500000000000000
]

let SHIP_TIMES: [[Int]] = [
    [
        1200,
        3600,
        7200,
        60
    ],
    [
        1800,
        3600,
        10800
    ],
    [
        2700,
        5400,
        14400
    ],
    [
        5400,
        14400,
        28800
    ],
    [
        10800,
        21600,
        43200
    ],
    [
        14400,
        43200,
        86400
    ],
    [
        21600,
        57600,
        108000
    ],
    [
        28800,
        86400,
        172800
    ],
    [
        43200,
        129600,
        259200
    ],
    [
        86400,
        172800,
        345600
    ],
    [
        172800,
        259200,
        345600
    ],
]

func getImageFromAfxID(AFX_ID: Int) -> String {
    switch AFX_ID {
    case 23:
        return "afx_puzzle_cube_4"
    case 0:
        return "afx_lunar_totem_4"
    case 6:
        return "afx_demeters_necklace_4"
    case 7:
        return "afx_vial_martian_dust_4"
    case 21:
        return "afx_aurelian_brooch_4"
    case 12:
        return "afx_tungsten_ankh_4"
    case 8:
        return "afx_ornate_gusset_4"
    case 3:
        return "afx_neo_medallion_4"
    case 30:
        return "afx_mercurys_lens_4"
    case 4:
        return "afx_beak_of_midas_4"
    case 22:
        return "afx_carved_rainstick_4"
    case 27:
        return "afx_interstellar_compass_4"
    case 9:
        return "afx_the_chalice_4"
    case 11:
        return "afx_phoenix_feather_4"
    case 24:
        return "afx_quantum_metronome_4"
    case 28:
        return "afx_dilithium_monocle_4"
    case 29:
        return "afx_titanium_actuator_4"
    case 25:
        return "afx_ship_in_a_bottle_4"
    case 26:
        return "afx_tachyon_deflector_4"
    case 10:
        return "afx_book_of_basan_4"
    case 5:
        return "afx_light_eggendil_4"
    case 33:
        return "afx_lunar_stone_4"
    case 32:
        return "afx_shell_stone_4"
    case 1:
        return "afx_tachyon_stone_4"
    case 37:
        return "afx_terra_stone_4"
    case 34:
        return "afx_soul_stone_4"
    case 31:
        return "afx_dilithium_stone_4"
    case 36:
        return "afx_quantum_stone_4"
    case 38:
        return "afx_life_stone_4"
    case 40:
        return "afx_clarity_stone_4"
    case 39:
        return "afx_prophecy_stone_4"
    case 17:
        return "afx_gold_meteorite_3"
    case 18:
        return "afx_tau_ceti_geode_3"
    case 43:
        return "afx_solar_titanium_3"
    default:
        return ""
    }
}

/*
 let FUEL_RATES = [
 5,000,000,
 200,000,000,
 3,000,000,000,
 50,000,000,000,
 75,000,000,000,
 100,000,000,000,
 125,000,000,000,
 150,000,000,000
 ]
 
 let TOTAL_FUEL_AMOUNTS = [
 [ // Chicken One
 2,000,000,
 3,000,000,
 10,000,000,
 100,000
 ],
 [ // Chicken Nine
 10,000,000,
 15,000,000,
 25,000,000
 ],
 [ // Chicken Heavy
 100,000,000,
 55,000,000,
 100,000,000
 ],
 [ // BCR
 300,000,000,
 475,000,000,
 405,000,000
 ],
 [ // Quintillion Chicken
 6,000,000,000,
 12,000,000,000,
 35,000,000,000
 ],
 [ // Cornish-Hen Corvette
 17,000,000,000,
 23,000,000,000,
 30,500,000,000
 ],
 [ // Galeggtica
 60,000,000,000,
 100,000,000,000,
 151,000,000,000
 ],
 [ // Defihent
 250,000,000,000,
 400,000,000,000,
 525,000,000,000
 ],
 [ // Voyegger
 2,000,000,000,000,
 3,000,000,000,000,
 4,100,000,000,000
 ],
 [ // Henerprise
 4,000,000,000,000,
 9,000,000,000,000,
 10,000,000,000,000,
 ],
 [ // Attregies Henliner
 11,000,000,000,000,
 16,000,000,000,000,
 20,000,000,000,000
 ]
 ]
 */
