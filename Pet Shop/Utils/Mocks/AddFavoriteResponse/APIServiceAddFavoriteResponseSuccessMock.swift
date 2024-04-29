//
//  APIServiceFavoriteResponseSuccessMock.swift
//  Pet ShopTests
//
//  Created by Lakshmi on 24/04/24.
//

#if DEBUG
import Foundation

class APIServiceAddFavoriteResponseSuccessMock: APIService {
    func makeRequest<T>(session: URLSession, for endpoint: any Pet_Shop.Endpoint) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "FavoriteResponseData", type: FavoriteResponse.self) as! T
    }
    
    func makeRequest<T>(session: URLSession, for endpoint: any Pet_Shop.Endpoint) async throws -> (data: T, paginationCount: Int) where T : Decodable, T : Encodable {
        return (try StaticJSONMapper.decode(file: "FavoriteResponseData", type: FavoriteResponse.self) as! T, 0)
    }
    
    
}
#endif
