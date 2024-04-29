//
//  APIError.swift
//  Pet Shop
//
//  Created by Lakshmi on 17/04/24.
//

import Foundation

enum NetworkError: Error, Equatable {
    case unableToGenerateRequest
    case invalidEndpoint
    case parsingError
    case invalidResponseHeader
    case serverError(statusCode: Int)
    case rateLimitExceeded
    case duplicateFavorite
    
    var description: String {
        switch self {
        case .unableToGenerateRequest:
            return "Network Error! Unable to generate request"
        case .invalidEndpoint:
            return "Network Error! Invalid network adress"
        case .parsingError:
            return "Parsing Error! Error occured when parsing data"
        case .invalidResponseHeader:
            return "Network Error! Invalid response header"
        case .serverError(statusCode: let code):
            return "Network Error! Error Occured with status code \(code)"
        case .rateLimitExceeded:
            return "Network Error! Too many request"
        case .duplicateFavorite:
            return "You have added to favorite"
        }
    }
}

protocol APIService {
    func makeRequest<T: Codable>(session: URLSession, for endpoint: Endpoint) async throws -> T
    func makeRequest<T: Codable>(session: URLSession, for endpoint: Endpoint) async throws -> (data: T, paginationCount: Int)
}

struct APIServiceImpl: APIService {
    
    static let shared = APIServiceImpl()
    
    func makeRequest<T: Codable>(session: URLSession = .shared, for endpoint: Endpoint) async throws -> T {
        guard let request = endpoint.generateURLRequest() else {
            throw NetworkError.unableToGenerateRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidEndpoint
        }
        
      guard (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) else {
          if httpResponse.statusCode == 429 {
              throw NetworkError.rateLimitExceeded
          } else if httpResponse.statusCode == 400 {
              if let responseData = String(data: data, encoding: .utf8), responseData.contains("DUPLICATE_FAVOURITE") {
                  throw NetworkError.duplicateFavorite
              } else {
                  throw NetworkError.serverError(statusCode: httpResponse.statusCode)
              }
          } else {
              throw NetworkError.serverError(statusCode: httpResponse.statusCode)
          }
      }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            print(error)
            throw NetworkError.parsingError
        }
    }
    
    func makeRequest<T: Codable>(session: URLSession = .shared, for endpoint: Endpoint) async throws -> (data: T, paginationCount: Int) {
        guard let request = endpoint.generateURLRequest() else {
            throw NetworkError.unableToGenerateRequest
        }
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidEndpoint
        }
      
        guard (httpResponse.statusCode >= 200 && httpResponse.statusCode < 300) else {
          if httpResponse.statusCode == 429 {
              throw NetworkError.rateLimitExceeded
          } else {
              throw NetworkError.serverError(statusCode: httpResponse.statusCode)
          }
        }
        
        guard let countString = httpResponse.allHeaderFields["pagination-count"] as? String,
              let paginationCount = Int(countString) else {
            throw NetworkError.invalidResponseHeader
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return (result, paginationCount)
        } catch {
            print(error)
            throw NetworkError.parsingError
        }
    }
}
