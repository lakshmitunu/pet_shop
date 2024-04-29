//
//  EndPoint.swift
//  Pet Shop
//
//  Created by Lakshmi on 17/04/24.
//

import Foundation

protocol Endpoint {
    var scheme: String { get }
    var baseURL: String { get }
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    var method: String { get }
    func generateURLRequest() -> URLRequest?
}
