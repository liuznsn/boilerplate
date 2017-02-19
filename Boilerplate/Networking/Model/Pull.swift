//
//	Pull.swift
//
//	Create by Leo on 15/2/2017
//	Copyright © 2017. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


public struct Pull : Mappable{
    
    var links : Link?
    var assignee : AnyObject?
    var assignees : [AnyObject]?
    var base : Base?
    var body : String?
    var closedAt : AnyObject?
    var commentsUrl : String?
    var commitsUrl : String?
    var createdAt : String?
    var diffUrl : String?
    var head : Base?
    var htmlUrl : String?
    var id : Int?
    var issueUrl : String?
    var locked : Bool?
    var mergeCommitSha : String?
    var mergedAt : AnyObject?
    var milestone : AnyObject?
    var number : Int?
    var patchUrl : String?
    var reviewCommentUrl : String?
    var reviewCommentsUrl : String?
    var state : String?
    var statusesUrl : String?
    var title : String?
    var updatedAt : String?
    var url : String?
    var user : Owner?
    
    
    public init?(map: Map){}

    public mutating func mapping(map: Map)
    {
        links <- map["_links"]
        assignee <- map["assignee"]
        assignees <- map["assignees"]
        base <- map["base"]
        body <- map["body"]
        closedAt <- map["closed_at"]
        commentsUrl <- map["comments_url"]
        commitsUrl <- map["commits_url"]
        createdAt <- map["created_at"]
        diffUrl <- map["diff_url"]
        head <- map["head"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        issueUrl <- map["issue_url"]
        locked <- map["locked"]
        mergeCommitSha <- map["merge_commit_sha"]
        mergedAt <- map["merged_at"]
        milestone <- map["milestone"]
        number <- map["number"]
        patchUrl <- map["patch_url"]
        reviewCommentUrl <- map["review_comment_url"]
        reviewCommentsUrl <- map["review_comments_url"]
        state <- map["state"]
        statusesUrl <- map["statuses_url"]
        title <- map["title"]
        updatedAt <- map["updated_at"]
        url <- map["url"]
        user <- map["user"]
        
    }
    
}
