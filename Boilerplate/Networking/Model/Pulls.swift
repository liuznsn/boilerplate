//
//	Pulls.swift
//
//	Create by Leo on 7/3/2018

import Foundation

struct Pulls : Codable {

	let title : String?
	let user : Owner?

	enum CodingKeys: String, CodingKey {
		case title = "title"
		case user = "user"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		user = try values.decodeIfPresent(Owner.self, forKey: .user)
	}


}
