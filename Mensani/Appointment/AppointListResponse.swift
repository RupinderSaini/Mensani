//
//  AppointListResponse.swift
//  Mensani
//
//  Created by apple on 12/07/23.
//

import Foundation

// MARK: - AppointListResponse
struct AppointListResponse: Codable {
    let data: DataAppintList
    let status, message: String
}

// MARK: - DataClass
struct DataAppintList: Codable {
    let booking: [Booking]
}

// MARK: - Booking
struct Booking: Codable {
    let endTime, athleteID: String
    let appointmentID, id: Int
    let athleteName, startTime: String
    let therapistID: Int
    let therapistName, date: String

    enum CodingKeys: String, CodingKey {
        case endTime = "end_time"
        case athleteID = "athlete_id"
        case appointmentID = "appointment_id"
        case id
        case athleteName = "athlete_name"
        case startTime = "start_time"
        case therapistID = "therapist_id"
        case therapistName = "therapist_name"
        case date
    }
}
