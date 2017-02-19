//
//	Issues.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.

import Foundation
import ObjectMapper

public struct Issues :Mappable{
    
    var assignee : AnyObject?
    var assignees : [AnyObject]?
    var body : String?
    var closedAt : AnyObject?
    var comments : Int?
    var commentsUrl : String?
    var createdAt : String?
    var eventsUrl : String?
    var htmlUrl : String?
    var id : Int?
    var labels : [AnyObject]?
    var labelsUrl : String?
    var locked : Bool?
    var milestone : AnyObject?
    var number : Int?
    var pullRequest : PullRequest?
    var repositoryUrl : String?
    var state : String?
    var title : String?
    var updatedAt : String?
    var url : String?
    var user : Owner?
    
    
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        assignee <- map["assignee"]
        assignees <- map["assignees"]
        body <- map["body"]
        closedAt <- map["closed_at"]
        comments <- map["comments"]
        commentsUrl <- map["comments_url"]
        createdAt <- map["created_at"]
        eventsUrl <- map["events_url"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        labels <- map["labels"]
        labelsUrl <- map["labels_url"]
        locked <- map["locked"]
        milestone <- map["milestone"]
        number <- map["number"]
        pullRequest <- map["pull_request"]
        repositoryUrl <- map["repository_url"]
        state <- map["state"]
        title <- map["title"]
        updatedAt <- map["updated_at"]
        url <- map["url"]
        user <- map["user"]
        
    }
    
}
