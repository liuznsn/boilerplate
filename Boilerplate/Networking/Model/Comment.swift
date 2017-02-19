//
//	Comment.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.

import Foundation
import ObjectMapper


public struct Comment : Mappable{
    
    var href : String?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        href <- map["href"]
        
    }
}
