//
//  SelfListResponse.swift
//  Mensani
//
//  Created by apple on 22/06/23.
//

import Foundation

// MARK: - SelfListResponse
struct SelfListResponse: Codable {
    let data: [DatumSelf]
    let status, message: String
}

// MARK: - Datum
struct DatumSelf: Codable {
    let audioName: String
    let recording: String
    let id, flag , type: Int

    enum CodingKeys: String, CodingKey {
        case audioName = "audio_name"
        case recording, id, flag, type
    }
}
