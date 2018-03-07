//
//	Repositories.swift
//
//	Create by Leo on 6/3/2018

import Foundation

struct Repositories : Codable {

	let incompleteResults : Bool?
	let items : [Repository]?
	let totalCount : Int?

	enum CodingKeys: String, CodingKey {
		case incompleteResults = "incomplete_results"
		case items = "items"
		case totalCount = "total_count"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		incompleteResults = try values.decodeIfPresent(Bool.self, forKey: .incompleteResults)
		items = try values.decodeIfPresent([Repository].self, forKey: .items)
		totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
	}


}
