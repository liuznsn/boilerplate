//
//  GitHubAPI.swift
//  Boilerplate
//
//  Created by Leo on 2017/2/8.
//  Copyright © 2017年 Leo. All rights reserved.
//

import Foundation
import Moya

public var stubJsonPath = ""

public var GithubProvider = MoyaProvider<GitHub>(
    endpointClosure:endpointClosure,
    requestClosure:requestClosure,
    plugins: [NetworkLoggerPlugin(verbose: false, responseDataFormatter: JSONResponseDataFormatter)]
)

public func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let requestClosure = { (endpoint: Endpoint<GitHub>, done: MoyaProvider.RequestResultClosure) in
    do {
        var request = try endpoint.urlRequest()
        // Modify the request however you like.
        done(.success(request))
    } catch {
       // done(.failure(MoyaError.underlying(error, <#Response?#>)))
    }
}

let endpointClosure = { (target: GitHub) -> Endpoint<GitHub> in
    let url = target.baseURL.appendingPathComponent(target.path).absoluteString
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    
    switch target {
    case .Token(let userString, let passwordString):
        let credentialData = "\(userString):\(passwordString)".data(using: String.Encoding.utf8)
        let base64Credentials = credentialData?.base64EncodedString()
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "Basic \(base64Credentials!)"])
    
    default:
        let environment = Environment()
        if !environment.tokenExists {
            return defaultEndpoint
        }
        
        return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "token \(environment.token!)"])
    }
    
}


public func url(route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum GitHub {
    case Token(username: String, password: String)
    case RepoSearch(query: String, page:Int)
    case TrendingReposSinceLastWeek(language: String, page:Int)
    case Repo(fullname: String)
    case RepoReadMe(fullname: String)
    case Pulls(fullname: String)
    case Issues(fullname: String)
    case Commits(fullname: String)
    case User
}


extension GitHub: TargetType {
    public var headers: [String : String]? {
       return ["Content-Type": "application/json"]
    }
    
    public var baseURL: URL { return URL(string: "https://api.github.com")! }

    public var path: String {
        switch self {
        case .Token(_, _):
            return "/authorizations"
        case .RepoSearch(_,_),
             .TrendingReposSinceLastWeek(_,_):
            return "/search/repositories"
        case .Repo(let fullname):
            return "/repos/\(fullname)"
        case .RepoReadMe(let fullname):
            return "/repos/\(fullname)/readme"
        case .Pulls(let fullname):
            return "/repos/\(fullname)/pulls"
        case .Issues(let fullname):
            return "/repos/\(fullname)/issues"
        case .Commits(let fullname):
            return "/repos/\(fullname)/commits"
        case .User:
            return "/user"
            
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .Token(_, _):
            return .post
        case .RepoSearch(_),
             .TrendingReposSinceLastWeek(_,_),
             .Repo(_),
             .RepoReadMe(_),
             .Pulls(_),
             .Issues(_),
             .Commits(_),
             .User:
            return .get
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        return nil
    }
    
    public var task: Task {
        switch self {
        case .Token(_,_):
                let params: [String: Any] = [
                    "scopes": ["public_repo", "user"],
                    "note": "(\(NSDate()))"
                    ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .RepoSearch(let query,let page):
                let params: [String: Any] = ["q": query.urlEscaped,"page":page]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .TrendingReposSinceLastWeek(let language,let page):
            let lastWeek = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: Date())
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let params: [String: Any] = ["q" :"language:\(language) " + "created:>" + formatter.string(from: lastWeek!),
             "sort" : "stars",
             "order" : "desc",
             "page":page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
              return .requestPlain
        }
    }
    
    public var sampleData: Data {
        
        switch self {
         case   .RepoSearch(_),
                .TrendingReposSinceLastWeek(_,_):
            return StubResponse.fromJSONFile(filePath: stubJsonPath)
        default:
            return "".data(using: String.Encoding.utf8)!
        }
        
    }

}
