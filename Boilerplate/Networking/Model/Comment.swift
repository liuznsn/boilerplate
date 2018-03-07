//
//	Comment.swift
//
//	Create by Leo on 7/3/2018

import Foundation

struct Comment : Codable {

	let href : String?


	enum CodingKeys: String, CodingKey {
		case href = "href"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		href = try values.decodeIfPresent(String.self, forKey: .href)
	}


}
