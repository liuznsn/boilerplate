//
//  App.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import ObjectMapper

public struct App:Mappable{

    var clientId : String?
    var name : String?
    var url : String?

    public init?(map: Map){}
    
    mutating public func mapping(map: Map)
    {
        clientId <- map["client_id"]
        name <- map["name"]
        url <- map["url"]
    }
}
