//
//  Network.swift
//  Albumy
//
//  Created by Ali on 03/03/2023.
//

import Moya

public enum NetworkService {
    case getUser(id: String)
    case getAlbum(userId: String)
    case getPhotos(albumId: String)
}

extension NetworkService: TargetType {
    public var baseURL: URL {
        URL(string: "https://jsonplaceholder.typicode.com")!
    }
    
    public var path: String {
        switch self {
        case .getUser(_):
            return "/users"
        case .getAlbum(_):
            return "/albums"
        case .getPhotos(_):
            return "/photos"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getUser(_), .getAlbum(_), .getPhotos(_):
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .getUser(let id):
               return .requestParameters(parameters: ["id": id], encoding: URLEncoding.queryString)
        case .getAlbum(let userId):
            return .requestParameters(parameters: ["userId": userId], encoding: URLEncoding.queryString)
        case .getPhotos(let albumId):
            return .requestParameters(parameters: ["albumId": albumId], encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }    
}




