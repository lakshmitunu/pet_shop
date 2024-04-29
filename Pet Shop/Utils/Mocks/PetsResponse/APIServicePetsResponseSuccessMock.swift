//
//  APIServicePetsResponseSuccessMock.swift
//  Pet Shop
//
//  Created by Lakshmi on 24/04/24.
//

import Foundation

#if DEBUG
import Foundation

class APIServicePetsResponseSuccessMock: APIService {
    let mockTotalPetsExist = 100
    
    func makeRequest<T>(session: URLSession, for endpoint: any Pet_Shop.Endpoint) async throws -> T where T : Decodable, T : Encodable {
        return try StaticJSONMapper.decode(file: "PetsData", type: [Pet].self) as! T
    }
    
    func makeRequest<T>(session: URLSession, for endpoint: any Pet_Shop.Endpoint) async throws -> (data: T, paginationCount: Int) where T : Decodable, T : Encodable {
        return (try StaticJSONMapper.decode(file: "PetsData", type: [Pet].self) as! T, mockTotalPetsExist)
    }
}
#endif
