//
//  ImproveListResponse.swift
//  Mensani
//
//  Created by apple on 14/06/23.
//

import Foundation
typealias ImproResponse = [DatumImprovement]

// MARK: - NotificationListResponse
struct ImproveListResponse: Codable {
    let status, message: String
    let data: [DatumImprovement]
}
// MARK: - Datum
struct DatumImprovement: Codable {
    let id: Int
    let improvement: String
}

