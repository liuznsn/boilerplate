//
//	Commits.swift
//
//	Create by Leo on 7/3/2018

import Foundation

struct Commits : Codable {

	let commit : Commit?
    
	enum CodingKeys: String, CodingKey {
		case commit = "commit"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
	    commit = try values.decodeIfPresent(Commit.self, forKey: .commit)
    }


}
