//
//	Commit.swift
//
//	Create by Leo on 7/3/2018

import Foundation

struct CommitAuthor : Codable {
    let name : String?
    let email : String?
    let date : String?
   
    enum CodingKeys: String, CodingKey {
       case name = "name"
       case email = "email"
       case date = "date"
    }
    
    init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self.self, forKey: .name)
        email = try values.decodeIfPresent(String.self.self, forKey: .email)
        date = try values.decodeIfPresent(String.self.self, forKey: .date)
    }
}


struct Commit : Codable {

	let author : CommitAuthor?
	//let commentCount : Int?
	//let committer : Committer?
	let message : String?
	//let tree : Tree?
	//let url : String?
	//let verification : Verification?


	enum CodingKeys: String, CodingKey {
		case author = "author"
		//case commentCount = "comment_count"
		//case committer
		case message = "message"
		//case tree
		//case url = "url"
		//case verification
	}
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		author = try values.decodeIfPresent(CommitAuthor.self, forKey: .author)
		//commentCount = try values.decodeIfPresent(Int.self, forKey: .commentCount)
		//committer = try Committer(from: decoder)
		message = try values.decodeIfPresent(String.self, forKey: .message)
		//tree = try Tree(from: decoder)
		//url = try values.decodeIfPresent(String.self, forKey: .url)
		//verification = try Verification(from: decoder)
	}

}
