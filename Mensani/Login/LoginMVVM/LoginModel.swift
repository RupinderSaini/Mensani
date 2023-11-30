//
//  LoginModel.swift
//  Mensani
//
//  Created by apple on 09/05/23.
//

import Foundation

struct LoginModel: Codable {
    let status: String
    let data: DataClass
    let message: String
}

// MARK: - DataClass
struct DataClass: Codable {
    let token, name: String
    let  id: Int
    let email: String
}

