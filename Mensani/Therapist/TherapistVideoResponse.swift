//
//  TherapistVideoResponse.swift
//  Mensani
//
//  Created by Protolabz MacbookPro2 on 06/12/23.
//

import Foundation
struct TherapistVideoResponse: Codable {
    let status: String
    let data: [DatumTVideos]
    let message: String
}

// MARK: - Datum
struct DatumTVideos: Codable {
    let thumbnail: String
       let video: String
       let supportType: JSONNull?
       let id, count: Int
       let price, title: String

       enum CodingKeys: String, CodingKey {
           case thumbnail, video
           case supportType = "support_type"
           case id, count, price, title
       }
   }






// MARK: - Encode/decode helpers

