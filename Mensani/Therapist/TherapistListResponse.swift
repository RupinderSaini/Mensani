//
//  TherapistListResponse.swift
//  Mensani
//
//  Created by apple on 06/07/23.
//

import Foundation

// MARK: - TherapistListResponse
struct TherapistListResponse: Codable {
    let status, message: String
    let data: [DatumTherapist]
}


// MARK: - Datum
struct DatumTherapist: Codable {
    let id: Int
    let name, email: String
    let image: String?
    let phone, experience: String
    let hourlyRate: Float
    let degree, license, sport: String
    let proUser: Int
    let completed, activeClient: String
    let status: Int

    enum CodingKeys: String, CodingKey {
        case id, name, email, image, phone, experience
        case hourlyRate = "hourly_rate"
        case degree, license, sport
        case proUser = "pro_user"
        case completed
        case activeClient = "active_client"
        case status
    }
}
