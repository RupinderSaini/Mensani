//
//  SportsListResponse.swift
//  Mensani
//
//  Created by apple on 20/06/23.
//

import Foundation


struct SportsListResponse: Codable {
    let status, message: String
    let data: [DatumSports]
}


struct DatumSports: Codable {
    let id: Int
    let sport: String
}
