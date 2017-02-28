//
//  StubResponse.swift
//  Boilerplate
//
//  Created by Leo on 2/28/17.
//  Copyright © 2017 Leo. All rights reserved.
//

import Foundation


class StubResponse {
    static func fromJSONFile(filePath:String) -> Data {
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            fatalError("Invalid data from json file")
        }
        return data
    }
}
