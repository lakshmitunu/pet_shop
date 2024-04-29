//
//  APIServiceBreedsResponseSuccesMock.swift
//  Pet ShopTests
//
//  Created by Lakshmi on 24/04/24.
//

#if DEBUG
import Foundation

class APIServiceBreedsResponseSuccessMock: APIService {
    let mockTotalBreedsExist = 100
    
    func makeRequest<T>(session: URLSession, for endpoint: any Pet_Shop.Endpoint) async throws -> T where T : Decodable, T : Encodable {
        if T.self == Pet.self {
            return try StaticJSONMapper.decode(file: "PetData", type: Pet.self) as! T
        } else {
            return try StaticJSONMapper.decode(file: "BreedsData", type: [Breed].self) as! T
        }
    }
    
    func makeRequest<T>(session: URLSession, for endpoint: any Pet_Shop.Endpoint) async throws -> (data: T, paginationCount: Int) where T : Decodable, T : Encodable {
        return (try StaticJSONMapper.decode(file: "BreedsData", type: [Breed].self) as! T, mockTotalBreedsExist)
    }
}
#endif
