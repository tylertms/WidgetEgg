//
//  SecureAPI.swift
//  WidgetEgg
//
//  Created by Tyler on 6/12/24.
//

import Foundation
import CryptoKit
import zlib

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

func decodeAuthenticatedMessagePayload(serializedBytes: Data) throws -> Data {
    let authMessage = try Ei_AuthenticatedMessage(serializedBytes: serializedBytes)
    if authMessage.compressed {
        return try decompressZlib(authMessage.message, originalSize: authMessage.originalSize)
    }

    return authMessage.message
}

private func decompressZlib(_ data: Data, originalSize: UInt32) throws -> Data {
    let compressed = [UInt8](data)
    var decompressed = [UInt8](repeating: 0, count: max(Int(originalSize), data.count * 4, 1024))

    while true {
        var decompressedSize = uLongf(decompressed.count)
        let status = uncompress(&decompressed, &decompressedSize, compressed, uLong(compressed.count))

        if status == Z_OK {
            return Data(decompressed.prefix(Int(decompressedSize)))
        }

        if status != Z_BUF_ERROR {
            throw NSError(domain: "AuthenticatedMessage", code: Int(status), userInfo: nil)
        }

        decompressed = [UInt8](repeating: 0, count: decompressed.count * 2)
    }
}
