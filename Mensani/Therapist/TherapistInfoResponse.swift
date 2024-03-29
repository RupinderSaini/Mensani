//
//  TherapistInfoResponse.swift
//  Mensani
//
//  Created by apple on 07/07/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let therapistInfoResponse = try? JSONDecoder().decode(TherapistInfoResponse.self, from: jsonData)

import Foundation

// MARK: - TherapistInfoResponse
struct TherapistInfoResponse: Codable {
    let data: DataTherapist
    let message, status: String
}

// MARK: - DataClass
struct DataTherapist: Codable {
    let therapistProfile: TherapistProfile
    let therapistReview: [TherapistReview]
    let isActive: Int

    enum CodingKeys: String, CodingKey {
        case therapistProfile = "therapist_profile"
        case therapistReview = "therapist_review"
        case isActive = "is_active"
    }
}

// MARK: - TherapistProfile
struct TherapistProfile: Codable {
    let experience, phone: String
    let hourlyRate: String
    let completed: String
    let status: Int
    let image: String
    let activeClient: String
    let id: Int
    let license : String?
    let sport, degree, email, name, bio: String
    let proUser: Int
    let personalQuote : String?

    enum CodingKeys: String, CodingKey {
        case experience, phone, license
        case hourlyRate = "hourly_rate"
        case completed, status, image , bio
        case activeClient = "active_client"
        case id, sport, degree, email, name
        case proUser = "pro_user"
        case personalQuote = "personal_quote"
    }
}

// MARK: - TherapistReview
struct TherapistReview: Codable {
    let duration, updatedAt: String
    let id: Int
    let athlete: Athlete
    let therapistID, athleteID: Int
    let createdAt, feedback, stars: String

    enum CodingKeys: String, CodingKey {
        case duration
        case updatedAt = "updated_at"
        case id, athlete
        case therapistID = "therapist_id"
        case athleteID = "athlete_id"
        case createdAt = "created_at"
        case feedback, stars
    }
}

// MARK: - Athlete
struct Athlete: Codable {
    let id: Int
    let image: String?
    let name: String
    let email: String
}


