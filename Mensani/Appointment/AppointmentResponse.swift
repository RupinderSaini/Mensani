//
//  AppointmentResponse.swift
//  Mensani
//
//  Created by apple on 11/07/23.
//

import Foundation


// MARK: - AppointmentResponse
struct AppointmentResponse: Codable {
    let message, status: String
    let data: DataAppoint
}

// MARK: - DataClass
struct DataAppoint: Codable {
    let id: Int
    let timeSlot: [TimeSlot]
    let startTime, endTime, therapistID: String
  
    let day: String
   

    enum CodingKeys: String, CodingKey {
        case id
        case timeSlot = "time_slot"
        case startTime = "start_time"
        case endTime = "end_time"
        case therapistID = "therapist_id"
     
        case day
      
    }
}

// MARK: - TimeSlot
struct TimeSlot: Codable {
    let slotEndTime, therapistID, slotStartTime: String
    let booking, appointmentsID: Int

    enum CodingKeys: String, CodingKey {
        case slotEndTime = "slot_end_time"
        case therapistID = "therapist_id"
        case slotStartTime = "slot_start_time"
        case booking
        case appointmentsID = "appointments_id"
    }
}

