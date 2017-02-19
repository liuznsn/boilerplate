//
//  File.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import ObjectMapper

public struct Plan : Mappable{

    var collaborators : Int?
    var name : String?
    var privateRepos : Int?
    var space : Int?

    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        collaborators <- map["collaborators"]
        name <- map["name"]
        privateRepos <- map["private_repos"]
        space <- map["space"]
        
    }
}
