//
//  NotificationListResponse.swift
//  Mensani
//
//  Created by apple on 02/06/23.
//

import Foundation

typealias NotificationResponse = [DatumNoti]


struct NotificationListResponse: Codable {
    let message, status: String
    let data: [DatumNoti]
}

// MARK: - Datum
struct DatumNoti: Codable {
    let title, description  , createdAt: String
    let id: Int
    
    enum CodingKeys: String, CodingKey {
            case title
            case createdAt = "created_at"
            case description, id
        }
}
