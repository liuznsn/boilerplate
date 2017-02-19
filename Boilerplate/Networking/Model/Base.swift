//
//	Base.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.
import Foundation
import ObjectMapper


public struct Base:Mappable{
    
    var label : String?
    var ref : String?
    var repo : Repository?
    var sha : String?
    var user : Owner?
    
    
    public init?(map: Map){}
    
    public mutating func mapping(map: Map)
    {
        label <- map["label"]
        ref <- map["ref"]
        repo <- map["repo"]
        sha <- map["sha"]
        user <- map["user"]
        
    }
    
    
}
