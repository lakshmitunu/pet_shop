//
//  APIEndpointTests.swift
//  Pet ShopTests
//
//  Created by Ferry Dwianta P on 23/04/24.
//

import XCTest
@testable import Pet_Shop

final class PetAPIEndpointTests: XCTestCase {
    
    func test_with_breeds_endpoint_request_is_valid(){
        let page = 0
        let endpoint = PetAPI.breeds(page: page)
        
        XCTAssertEqual(endpoint.baseURL, "api.thedogapi.com")
        XCTAssertEqual(endpoint.path, "/v1/breeds")
        XCTAssertEqual(endpoint.method, "get")
        XCTAssertEqual(endpoint.queryItems, [
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "page", value: "\(page)")
        ])
        XCTAssertNil(endpoint.body)
        
        XCTAssertEqual(endpoint.generateURLRequest()?.url?.absoluteString, "https://api.thedogapi.com/v1/breeds?limit=10&page=0")
    }
    
    func test_with_pet_endpoint_request_is_valid(){
        let petId = "BJa4kxc4X"
        let endpoint = PetAPI.pet(petId: petId)
        
        XCTAssertEqual(endpoint.baseURL, "api.thedogapi.com")
        XCTAssertEqual(endpoint.path, "/v1/images/\(petId)")
        XCTAssertEqual(endpoint.method, "get")
        XCTAssertEqual(endpoint.queryItems, [])
        XCTAssertNil(endpoint.body)
        
        XCTAssertEqual(endpoint.generateURLRequest()?.url?.absoluteString, "https://api.thedogapi.com/v1/images/\(petId)?")
    }
    
    func test_with_pets_endpoint_request_is_valid(){
        let breedId = 1
        let page = 0
        let endpoint = PetAPI.pets(breedId: breedId, page: page)
        
        XCTAssertEqual(endpoint.baseURL, "api.thedogapi.com")
        XCTAssertEqual(endpoint.path, "/v1/images/search")
        XCTAssertEqual(endpoint.method, "get")
        XCTAssertEqual(endpoint.queryItems, [
            URLQueryItem(name: "breed_ids", value: "\(breedId)"),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "page", value: "\(page)"),
        ])
        XCTAssertNil(endpoint.body)
        
        XCTAssertEqual(endpoint.generateURLRequest()?.url?.absoluteString, "https://api.thedogapi.com/v1/images/search?breed_ids=\(breedId)&limit=10&page=\(page)")
    }
    
    func test_with_addFavorite_endpoint_request_is_valid(){
        let petId = "BJa4kxc4X"
        let userId = "test@gmail.com"
        let endpoint = PetAPI.addFavorite(petId: petId, userId: userId)
        
        XCTAssertEqual(endpoint.baseURL, "api.thedogapi.com")
        XCTAssertEqual(endpoint.path, "/v1/favourites")
        XCTAssertEqual(endpoint.method, "post")
        XCTAssertEqual(endpoint.queryItems, [])
        
        let body: [String: Any] = [
            "image_id": "\(petId)",
            "sub_id": "\(userId)"
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: body)
        XCTAssertEqual(endpoint.body, bodyData)
        
        XCTAssertEqual(endpoint.generateURLRequest()?.url?.absoluteString, "https://api.thedogapi.com/v1/favourites?")
    }
    
    func test_with_favorites_endpoint_request_is_valid(){
        let userId = "test@gmail.com"
        let endpoint = PetAPI.favorites(userId: userId)
        
        XCTAssertEqual(endpoint.baseURL, "api.thedogapi.com")
        XCTAssertEqual(endpoint.path, "/v1/favourites")
        XCTAssertEqual(endpoint.method, "get")
        XCTAssertEqual(endpoint.queryItems, [
            URLQueryItem(name: "sub_id", value: String(userId)),
        ])
        XCTAssertNil(endpoint.body)
        
        XCTAssertEqual(endpoint.generateURLRequest()?.url?.absoluteString, "https://api.thedogapi.com/v1/favourites?sub_id=\(userId)")
    }
    
    func test_with_deleteFavorite_endpoint_request_is_valid(){
        let favoriteId = 94056
        let endpoint = PetAPI.deleteFavorite(id: favoriteId)
        
        XCTAssertEqual(endpoint.baseURL, "api.thedogapi.com")
        XCTAssertEqual(endpoint.path, "/v1/favourites/\(favoriteId)")
        XCTAssertEqual(endpoint.method, "delete")
        XCTAssertEqual(endpoint.queryItems, [])
        XCTAssertNil(endpoint.body)
        
        XCTAssertEqual(endpoint.generateURLRequest()?.url?.absoluteString, "https://api.thedogapi.com/v1/favourites/\(favoriteId)?")
    }
    
}
