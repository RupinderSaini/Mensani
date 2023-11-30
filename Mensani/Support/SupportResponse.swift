//
//  SupportResponse.swift
//  Mensani
//
//  Created by apple on 30/06/23.
//

import Foundation
// MARK: - SupportResponse
struct SupportResponse: Codable {
    let status: String
    let data: [DatumVideos]
    let message: String
}

// MARK: - Datum
struct DatumVideos: Codable {
    let video: String?
    let ebookURL: String
    let updatedAt, userID: String
    let userType: JSONNull?
    let title: String
    let thumbnail: String
    let id: Int
    let price: String
    let flag: Int
    let createdAt: String
    let supportType: String

    enum CodingKeys: String, CodingKey {
        case video
        case ebookURL = "ebook_url"
        case updatedAt = "updated_at"
        case userID = "user_id"
        case userType = "user_type"
        case title, thumbnail, id, price, flag
        case createdAt = "created_at"
        case supportType = "support_type"
    }
}





// MARK: - Encode/decode helpers

