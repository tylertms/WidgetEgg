//
//  tools.swift
//  WidgetEgg
//
//  Created by Tyler on 5/2/24.
//

import Foundation
import SwiftUI

func fetchActiveMissions(basicRequestInfo: Ei_BasicRequestInfo) async throws -> [Ei_MissionInfo] {
    guard let url = URL(string: MISSION_ENDPOINT) else { throw NSError(domain: "InvalidURL", code: 0, userInfo: nil) }
    
    
    guard let authMessage = buildSecureAuthMessage(data: try basicRequestInfo.serializedData()) else {
        throw NSError(domain: "InvalidSecrets", code: 0, userInfo: nil)
    }
    
    let parameters = ["data": try authMessage.serializedData().base64EncodedString()]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = parameters.queryString.data(using: .utf8)
    
    let (data, _) = try await URLSession.shared.data(for: request)
    guard let b64decoded = Data(base64Encoded: data) else {
        throw NSError(domain: "InvalidData", code: 0, userInfo: nil)
    }
    
    let authMessageDecoded = try Ei_AuthenticatedMessage(serializedBytes: b64decoded).message
    let activeMissionsResponse = try Ei_GetActiveMissionsResponse(serializedBytes: authMessageDecoded)
    let activeMissions = activeMissionsResponse.activeMissions
    
    return activeMissions
}

func fetchBackup(basicRequestInfo: Ei_BasicRequestInfo) async throws -> Ei_Backup {
    guard let url = URL(string: BACKUP_ENDPOINT) else { throw NSError(domain: "InvalidURL", code: 0, userInfo: nil) }
    
    let firstContactRequest = Ei_EggIncFirstContactRequest.with {
        $0.rinfo = basicRequestInfo
        $0.eiUserID = basicRequestInfo.eiUserID
    }
    let parameters = ["data": try firstContactRequest.serializedData().base64EncodedString()]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = parameters.queryString.data(using: .utf8)
    
    let (data, _) = try await URLSession.shared.data(for: request)
    guard let b64decoded = Data(base64Encoded: data) else { throw NSError(domain: "InvalidData", code: 0, userInfo: nil) }
    
    let backup = try Ei_EggIncFirstContactResponse(serializedBytes: b64decoded).backup
    guard backup.hasChecksum else { throw NSError(domain: "InvalidData", code: 0, userInfo: nil) }
    
    return backup
}


func fetchData(EID: String) async throws -> ([Ei_MissionInfo], Ei_Backup.Artifacts) {
    let basicRequestInfo = getBasicRequestInfo(EID: EID)
    
    async let activeMissionsTask = fetchActiveMissions(basicRequestInfo: basicRequestInfo)
    async let backupTask = fetchBackup(basicRequestInfo: basicRequestInfo)
    
    let activeMissions = try await activeMissionsTask
    let backup = try await backupTask
    
    var fuelingMissions: [Ei_MissionInfo] = []
    
    var fuelingMission = backup.artifactsDb.fuelingMission
    if fuelingMission != Ei_MissionInfo() {
        fuelingMission.durationSeconds = getMissionDuration(mission: fuelingMission, epicResearch: backup.game.epicResearch)
        fuelingMissions.append(fuelingMission)
    }
    
    return (activeMissions + fuelingMissions, backup.artifacts)
}

func getBasicRequestInfo(EID: String) -> Ei_BasicRequestInfo {
    return Ei_BasicRequestInfo.with {
        $0.eiUserID = EID
        $0.clientVersion = 127
        $0.platform = "IOS"
    }
}
