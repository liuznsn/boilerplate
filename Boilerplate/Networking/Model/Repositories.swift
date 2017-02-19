//
//	Repositories.swift
//
//	Create by Leo on 13/2/2017
//	Copyright © 2017. All rights reserved.

import Foundation 
import ObjectMapper


public struct Repositories :Mappable{

	var incompleteResults : Bool?
	var items : [Repository]?
	var totalCount : Int?

    public init?(map: Map){}

	mutating public func mapping(map: Map)
	{
		incompleteResults <- map["incomplete_results"]
		items <- map["items"]
		totalCount <- map["total_count"]
	}
    
}
