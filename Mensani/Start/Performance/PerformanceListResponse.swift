//
//  PerformanceListResponse.swift
//  Mensani
//
//  Created by apple on 13/06/23.
//

import Foundation

typealias PerfResponse = [DatumPerformance]

// MARK: - NotificationListResponse
struct PerformanceListResponse: Codable {
    let status, message: String
    let data: [DatumPerformance]
}

// MARK: - Datum
struct DatumPerformance: Codable {
   
        let performance: String
        let id, sequence: Int
    

}

