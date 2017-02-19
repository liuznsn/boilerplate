//
//	Author.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


public struct ShortAuthor : Mappable{
    
    var date : String?
    var email : String?
    var name : String = ""
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        date <- map["date"]
        email <- map["email"]
        name <- map["name"]
        
    }
    
    
}
