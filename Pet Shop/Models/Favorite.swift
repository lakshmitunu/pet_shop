//
//  Favorite.swift
//  Pet Shop
//
//  Created by Lakshmi on 19/04/24.
//

import Foundation

struct Favorite: Codable, Hashable {
    let id: Int
    let userId, imageId, subId, createdAt: String
    var pet: Pet
    
    enum CodingKeys: String, CodingKey {
        case id
        case pet = "image"
        case userId = "user_id"
        case imageId = "image_id"
        case subId = "sub_id"
        case createdAt = "created_at"
    }
}

struct FavoriteResponse: Codable {
    let message: String
    let id: Int?
}
