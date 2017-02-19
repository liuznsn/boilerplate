//
//	Parent.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.

import Foundation
import ObjectMapper


public struct Parent : Mappable{
    
    var htmlUrl : String?
    var sha : String?
    var url : String?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        htmlUrl <- map["html_url"]
        sha <- map["sha"]
        url <- map["url"]
        
    }
    
}
