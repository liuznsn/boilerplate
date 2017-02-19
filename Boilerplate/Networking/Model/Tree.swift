//
//	Tree.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.
import Foundation
import ObjectMapper


public struct Tree :Mappable{
    
    var sha : String?
    var url : String?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        sha <- map["sha"]
        url <- map["url"]
        
    }
    
    
}
