//
//  HomeResponse.swift
//  Mensani
//
//  Created by apple on 15/06/23.
//

import Foundation

// MARK: - HomeResponse
struct HomeResponse: Codable {
    let status, message: String
    let data: DataClassHome
}

// MARK: - DataClass
struct DataClassHome: Codable {
    let id,daypoints, weeklypoints,monthlypoints: Int
    let question, answer: String

    let selftalksFlag, visualizationsFlag: Int
    let adminPoints: AdminPoints
    let todayplans: Todayplans
    let userProfile: UserProfile
    let seasonGoal: Goal
    let dreamsGoal: DreamsGoal
    let wellbeing: Wellbeing
    let selfTalk: SelfTalk
    let startGoal: Goal
    let postPerformance: PostPerformance
    let startSelftalk: StartSelftalk

    enum CodingKeys: String, CodingKey {
        case id, question, answer, daypoints, weeklypoints, monthlypoints
        case selftalksFlag = "selftalks_flag"
        case visualizationsFlag = "visualizations_flag"
        case adminPoints = "admin_points"
        case todayplans
        case userProfile = "user_profile"
        case seasonGoal = "season_goal"
        case dreamsGoal = "dreams_goal"
        case wellbeing
        case selfTalk = "self_talk"
        case startGoal = "start_goal"
        case postPerformance = "post_performance"
        case startSelftalk = "start_selftalk"
    }
}

// MARK: - AdminPoints
struct AdminPoints: Codable {
    let performace, startGoals, visualization, startSelftalks: Int

    enum CodingKeys: String, CodingKey {
        case performace
        case startGoals = "start_goals"
        case visualization
        case startSelftalks = "start_selftalks"
    }
}

// MARK: - DreamsGoal
struct DreamsGoal: Codable {
    let id: Int
    let dreamGoal: String

    enum CodingKeys: String, CodingKey {
        case id
        case dreamGoal = "dream_goal"
    }
}

// MARK: - PostPerformance
struct PostPerformance: Codable {
    let id: Int
    let performance: String
}

// MARK: - Goal
struct Goal: Codable {
    let id: Int
    let primaryGoal, secondaryGoal: String

    enum CodingKeys: String, CodingKey {
        case id
        case primaryGoal = "primary_goal"
        case secondaryGoal = "secondary_goal"
    }
}

// MARK: - SelfTalk
struct SelfTalk: Codable {
    let id: Int
    let roleModel: String
    let image: String
    let challenge: String
    let recording: String
    let audioName: JSONNull?

    enum CodingKeys: String, CodingKey {
        case id
        case roleModel = "role_model"
        case image, challenge, recording
        case audioName = "audio_name"
    }
}

// MARK: - StartSelftalk
struct StartSelftalk: Codable {
}

// MARK: - Todayplans
struct Todayplans: Codable {
    let id: Int
    let image: String
    let messageFrom, name, description, date: String
    let time, validity: String

    enum CodingKeys: String, CodingKey {
        case id, image
        case messageFrom = "message_from"
        case name, description, date, time, validity
    }
}

// MARK: - UserProfile
struct UserProfile: Codable {
    let id: Int
    let name, email: String
    let image: String
    let sportsName, subscriptionID, createdAt, time: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, image
        case sportsName = "sports_name"
        case subscriptionID = "subscription_id"
        case createdAt = "created_at"
        case time
    }
}

// MARK: - Wellbeing
struct Wellbeing: Codable {
    let id: Int
    let mood, thought: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
