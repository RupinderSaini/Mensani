//
//  TeamsResponse.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 07/11/23.
//

import Foundation
// MARK: - TeamsResponse
struct TeamsResponse: Codable {
    let status, message: String
    let data: [DatumTeams]
}

// MARK: - Datum
struct DatumTeams: Codable {
    let id: Int
    let teamName, coachName, coachEmail, asstName: String
    let asstEmail: String
    let status: Int
    let colorCode: String
    let graphicStatus: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case teamName = "team_name"
        case coachName = "coach_name"
        case coachEmail = "coach_email"
        case asstName = "asst_name"
        case asstEmail = "asst_email"
        case status
        case colorCode = "color_code"
        case graphicStatus = "graphic_status"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
