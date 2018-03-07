//
//	PullRequest.swift
//
//	Create by Leo on 6/3/2018

import Foundation

struct PullRequest : Codable {

	let diffUrl : String?
	let htmlUrl : String?
	let patchUrl : String?
	let url : String?


	enum CodingKeys: String, CodingKey {
		case diffUrl = "diff_url"
		case htmlUrl = "html_url"
		case patchUrl = "patch_url"
		case url = "url"
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		diffUrl = try values.decodeIfPresent(String.self, forKey: .diffUrl)
		htmlUrl = try values.decodeIfPresent(String.self, forKey: .htmlUrl)
		patchUrl = try values.decodeIfPresent(String.self, forKey: .patchUrl)
		url = try values.decodeIfPresent(String.self, forKey: .url)
	}


}
