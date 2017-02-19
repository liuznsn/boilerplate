//
//  User.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/17.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import ObjectMapper


public struct User : Mappable{
    
    var avatarUrl : String?
    var bio : AnyObject?
    var blog : AnyObject?
    var collaborators : Int?
    var company : AnyObject?
    var createdAt : String?
    var diskUsage : Int?
    var email : AnyObject?
    var eventsUrl : String?
    var followers : Int?
    var followersUrl : String?
    var following : Int?
    var followingUrl : String?
    var gistsUrl : String?
    var gravatarId : String?
    var hireable : AnyObject?
    var htmlUrl : String?
    var id : Int?
    var location : AnyObject?
    var login : String?
    var name : AnyObject?
    var organizationsUrl : String?
    var ownedPrivateRepos : Int?
    var plan : Plan?
    var privateGists : Int?
    var publicGists : Int?
    var publicRepos : Int?
    var receivedEventsUrl : String?
    var reposUrl : String?
    var siteAdmin : Bool?
    var starredUrl : String?
    var subscriptionsUrl : String?
    var totalPrivateRepos : Int?
    var twoFactorAuthentication : Bool?
    var type : String?
    var updatedAt : String?
    var url : String?
    
    public init(){}
    public init?(map: Map){}
    public mutating func mapping(map: Map)
    {
        avatarUrl <- map["avatar_url"]
        bio <- map["bio"]
        blog <- map["blog"]
        collaborators <- map["collaborators"]
        company <- map["company"]
        createdAt <- map["created_at"]
        diskUsage <- map["disk_usage"]
        email <- map["email"]
        eventsUrl <- map["events_url"]
        followers <- map["followers"]
        followersUrl <- map["followers_url"]
        following <- map["following"]
        followingUrl <- map["following_url"]
        gistsUrl <- map["gists_url"]
        gravatarId <- map["gravatar_id"]
        hireable <- map["hireable"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        location <- map["location"]
        login <- map["login"]
        name <- map["name"]
        organizationsUrl <- map["organizations_url"]
        ownedPrivateRepos <- map["owned_private_repos"]
        plan <- map["plan"]
        privateGists <- map["private_gists"]
        publicGists <- map["public_gists"]
        publicRepos <- map["public_repos"]
        receivedEventsUrl <- map["received_events_url"]
        reposUrl <- map["repos_url"]
        siteAdmin <- map["site_admin"]
        starredUrl <- map["starred_url"]
        subscriptionsUrl <- map["subscriptions_url"]
        totalPrivateRepos <- map["total_private_repos"]
        twoFactorAuthentication <- map["two_factor_authentication"]
        type <- map["type"]
        updatedAt <- map["updated_at"]
        url <- map["url"]
        
    }


}
