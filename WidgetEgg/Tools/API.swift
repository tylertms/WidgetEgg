//
//  tools.swift
//  WidgetEgg
//
//  Created by Tyler on 5/2/24.
//

import Foundation
import SwiftUI

func fetchActiveMissions(basicRequestInfo: Ei_BasicRequestInfo, resetIndex: UInt32 = 0) async throws -> [Ei_MissionInfo] {
    guard let url = URL(string: MISSION_ENDPOINT) else { throw NSError(domain: "InvalidURL", code: 0, userInfo: nil) }
    
    let getActiveMissionsRequest = Ei_GetActiveMissionsRequest.with {
        $0.rinfo = basicRequestInfo
        $0.resetIndex = resetIndex
    }
    
    guard let authMessage = buildSecureAuthMessage(data: try getActiveMissionsRequest.serializedData()) else {
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
    
    
    if activeMissionsResponse.success != true {
        throw NSError(domain: "Unsuccessful", code: 0, userInfo: nil)
    }

    return activeMissionsResponse.activeMissions
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


func fetchData(EID: String, virtue: Bool) async throws -> ([Ei_MissionInfo], Ei_Backup.Artifacts) {
    let basicRequestInfo = getBasicRequestInfo(EID: EID)
    
    let backup = try await fetchBackup(basicRequestInfo: basicRequestInfo)
    let activeMissions = try await fetchActiveMissions(basicRequestInfo: basicRequestInfo, resetIndex: backup.virtue.resets)
    
    var fuelingMissions: [Ei_MissionInfo] = []
    
    var fuelingMission = backup.artifactsDb.fuelingMission
    if fuelingMission != Ei_MissionInfo() {
        fuelingMission.durationSeconds = getMissionDuration(mission: fuelingMission, epicResearch: backup.game.epicResearch)
        fuelingMissions.append(fuelingMission)
    }
    
    var artifacts = virtue ? backup.virtue.afx : backup.artifacts
    if virtue { artifacts.tankLevel = backup.artifacts.tankLevel }
    
    return (activeMissions + fuelingMissions, artifacts)
}

func fetchCoop(EID: String, contract: String, coop: String) async throws -> Ei_ContractCoopStatusResponse {
    guard let url = URL(string: COOP_STATUS_ENDPOINT) else { throw NSError(domain: "InvalidURL", code: 0, userInfo: nil) }
    
    let basicRequestInfo = getBasicRequestInfo(EID: EID)
    let coopStatusRequest = Ei_ContractCoopStatusRequest.with {
        $0.clientVersion = 127
        $0.rinfo = basicRequestInfo
        $0.contractIdentifier = contract
        $0.coopIdentifier = coop
        $0.userID = EID
    }
    
    let parameters = ["data": try coopStatusRequest.serializedData().base64EncodedString()]
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.httpBody = parameters.queryString.data(using: .utf8)
    
    let (data, _) = try await URLSession.shared.data(for: request)
    guard let b64decoded = Data(base64Encoded: data) else { throw NSError(domain: "InvalidData", code: 0, userInfo: nil) }
    
    let authMessage = try Ei_AuthenticatedMessage(serializedBytes: b64decoded)
    let coopStatus = try Ei_ContractCoopStatusResponse(serializedBytes: authMessage.message)

    return coopStatus
}

func getBasicRequestInfo(EID: String) -> Ei_BasicRequestInfo {
    return Ei_BasicRequestInfo.with {
        $0.eiUserID = EID
        $0.clientVersion = 127
        $0.platform = "IOS"
    }
}
