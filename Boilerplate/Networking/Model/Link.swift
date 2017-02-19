//
//	Link.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.

import Foundation
import ObjectMapper


public struct Link:Mappable{
    
    var comments : Comment?
    var commits : Comment?
    var html : Comment?
    var issue : Comment?
    var reviewComment : Comment?
    var reviewComments : Comment?
    var linkSelf : Comment?
    var statuses : Comment?
    
    
    public init?(map: Map){}
    
    public mutating func mapping(map: Map)
    {
        comments <- map["comments"]
        commits <- map["commits"]
        html <- map["html"]
        issue <- map["issue"]
        reviewComment <- map["review_comment"]
        reviewComments <- map["review_comments"]
        self <- map["self"]
        statuses <- map["statuses"]
        
    }
    
}
