//
//  SecureAPI.swift
//  WidgetEgg
//
//  Created by Tyler on 6/12/24.
//

import Foundation
import CryptoKit

let env = Bundle.main.infoDictionary?["LSEnvironment"] as! Dictionary<String, String>

func buildSecureAuthMessage(data: Data) -> Ei_AuthenticatedMessage? {
    
    // The variables in production cannot be released publically
    // You must add these to your local environment to use this function
    
    guard let index = Int(env["INDEX"] ?? ""),
          let marker = UInt8(env["MARKER"] ?? ""),
          let key = env["KEY"]
    else {
        return nil
    }
    
    var copy = Data(data)
    copy[index % data.count] = marker
    
    let combinedData = copy + Data(key.utf8)
    let code = SHA256.hash(data: combinedData).map { String(format: "%02x", $0) }.joined()
    
    return Ei_AuthenticatedMessage.with { $0.message = data; $0.code = code }
}
