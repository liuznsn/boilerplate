//
//    Repository.swift
//
//    Create by Leo on 6/3/2018

import Foundation

public struct Repository : Codable {
    let descriptionField : String?
    let fullName : String?
    let language : String?
    let stargazersCount : Int?
    let forksCount : Int?
    enum CodingKeys: String, CodingKey {
        case descriptionField = "description"
        case fullName = "full_name"
        case language = "language"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
    }
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        descriptionField = try values.decodeIfPresent(String.self, forKey: .descriptionField)
        fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        language = try values.decodeIfPresent(String.self, forKey: .language)
        stargazersCount = try values.decodeIfPresent(Int.self, forKey: .stargazersCount)
        forksCount = try values.decodeIfPresent(Int.self, forKey: .forksCount)
    }
    
    
}

