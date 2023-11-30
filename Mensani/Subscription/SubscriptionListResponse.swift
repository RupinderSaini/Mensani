//
//  SubscriptionListResponse.swift
//  Mensani
//
//  Created by apple on 28/06/23.
//

import Foundation

struct SubscriptionListResponse: Codable {
    let message, status, subscriptionID: String
    let data: [DatumPlan]

    enum CodingKeys: String, CodingKey {
        case message, status
        case subscriptionID = "subscription_id"
        case data
    }
}

// MARK: - Datum
struct DatumPlan: Codable {
    let description, name, duration: String
    let id: Int
    let price: String
}
