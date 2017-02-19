//
//	Readme.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.

import Foundation
import ObjectMapper


public struct Readme : Mappable{
    
    var links : Link?
    var content : String?
    var downloadUrl : String?
    var encoding : String?
    var gitUrl : String?
    var htmlUrl : String?
    var name : String?
    var path : String?
    var sha : String?
    var size : Int?
    var type : String?
    var url : String?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        links <- map["_links"]
        content <- map["content"]
        downloadUrl <- map["download_url"]
        encoding <- map["encoding"]
        gitUrl <- map["git_url"]
        htmlUrl <- map["html_url"]
        name <- map["name"]
        path <- map["path"]
        sha <- map["sha"]
        size <- map["size"]
        type <- map["type"]
        url <- map["url"]
        
    }
    
    
}
