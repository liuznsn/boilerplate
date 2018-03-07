//
//	Authorizations.swift
//
//	Create by Leo on 6/3/2018

import Foundation

struct Authorizations : Codable {

	let token : String?

	enum CodingKeys: String, CodingKey {
		case token = "token"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		token = try values.decodeIfPresent(String.self, forKey: .token)
	}


}
