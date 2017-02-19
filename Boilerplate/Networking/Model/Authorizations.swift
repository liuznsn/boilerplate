//
//  Authorizations.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Authorizations:Mappable{
    
    var app : App?
    var createdAt : String?
    var fingerprint : AnyObject?
    var hashedToken : String?
    var id : Int?
    var note : String?
    var noteUrl : AnyObject?
    var scopes : [String]?
    var token : String?
    var tokenLastEight : String?
    var updatedAt : String?
    var url : String?

    public init?(map: Map){}
    
    mutating public func mapping(map: Map)
    {
        app <- map["app"]
        createdAt <- map["created_at"]
        fingerprint <- map["fingerprint"]
        hashedToken <- map["hashed_token"]
        id <- map["id"]
        note <- map["note"]
        noteUrl <- map["note_url"]
        scopes <- map["scopes"]
        token <- map["token"]
        tokenLastEight <- map["token_last_eight"]
        updatedAt <- map["updated_at"]
        url <- map["url"]
    }

}
