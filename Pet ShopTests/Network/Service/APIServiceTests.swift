//
//  APIServiceTests.swift
//  Pet ShopTests
//
//  Created by Ferry Dwianta P on 23/04/24.
//

import XCTest
@testable import Pet_Shop

final class APIServiceTests: XCTestCase {
    
    private var session: URLSession!
    private var url: URL!
    
    override func setUp() {
        url = URL(string: "https://api.thedogapi.com")
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLSessionProtocol.self]
        session = URLSession(configuration: configuration)
    }
    
    override func tearDown() {
        session = nil
        url = nil
    }
    
    func test_with_successful_response_is_valid() async throws {
        guard let path = Bundle.main.path(forResource: "BreedsData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the breeds data json file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, data)
        }
        
        let result: [Breed] = try await APIServiceImpl.shared.makeRequest(session: session, for: PetAPI.breeds(page: 0))
        
        let staticJson = try StaticJSONMapper.decode(file: "BreedsData", type: [Breed].self)
        XCTAssertEqual(result, staticJson)
    }
    
    func test_with_unsuccessful_response_code_in_invalid_range_is_invalid() async {
        let invalidStatusCode = 400
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: invalidStatusCode, httpVersion: nil, headerFields: nil)
            return (response!, nil)
        }
        
        do {
            let _: [Breed] = try await APIServiceImpl.shared.makeRequest(session: session, for: PetAPI.breeds(page: 0))
        } catch {
            guard let networkError = error as? NetworkError else {
                XCTFail("Wrong type of error, expecting NetworkError")
                return
            }
            
            XCTAssertEqual(networkError, NetworkError.serverError(statusCode: invalidStatusCode))
        }
    }
    
    func test_with_successful_response_with_invalid_json_is_invalid() async {
        guard let path = Bundle.main.path(forResource: "BreedsData", ofType: "json"),
              let data = FileManager.default.contents(atPath: path) else {
            XCTFail("Failed to get the breeds data json file")
            return
        }
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: 200, httpVersion: nil, headerFields: nil)
            return (response!, data)
        }
        
        do {
            let _: [Pet] = try await APIServiceImpl.shared.makeRequest(session: session, for: PetAPI.breeds(page: 0)) // Wrong type
        } catch {
            guard let networkError = error as? NetworkError else {
                XCTFail("Wrong type of error, expecting NetworkError")
                return
            }
            
            XCTAssertEqual(networkError, NetworkError.parsingError)
        }
    }
    
    func test_with_unsuccessful_response_code_with_rate_limit_exceeded_is_invalid() async {
        let invalidStatusCode = 429
        
        MockURLSessionProtocol.loadingHandler = {
            let response = HTTPURLResponse(url: self.url, statusCode: invalidStatusCode, httpVersion: nil, headerFields: nil)
            return (response!, nil)
        }
        
        do {
            let _: [Breed] = try await APIServiceImpl.shared.makeRequest(session: session, for: PetAPI.breeds(page: 0))
        } catch {
            guard let networkError = error as? NetworkError else {
                XCTFail("Wrong type of error, expecting NetworkError")
                return
            }
            
            XCTAssertEqual(networkError, NetworkError.rateLimitExceeded)
        }
    }
}
