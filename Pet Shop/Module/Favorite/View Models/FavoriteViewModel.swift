//
//  FavoriteViewModel.swift
//  Pet Shop
//
//  Created by Lakshmi on 19/04/24.
//

import SwiftUI

class FavoriteViewModel: ObservableObject {
    @Published private(set) var favorites = [Favorite]()
    @Published private(set) var cart = [Favorite]()
    @Published private(set) var isLoading = false
    @Published private(set) var alertMessage = ""
    @Published var isAlertActive = false
    @AppStorage("current_email") private var currentEmail = ""
    
    private var service = APIServiceImpl()
    
    @MainActor
    func getFavoritesData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if !currentEmail.isEmpty {
                var result: [Favorite] = try await service.makeRequest(for: PetAPI.favorites(userId: currentEmail))
                let favoritesFromDefaults = getFavoriteFromDefaults()
                for (index, _) in result.enumerated() {
                    if let priceFromDefaults = favoritesFromDefaults[String(result[index].id)] {
                        result[index].pet.price = priceFromDefaults as? Int
                    } else {
                        result[index].pet.price = Int.random(in: 50...200)
                    }
                }
                favorites = result
            } else {
                isAlertActive = true
                alertMessage = "User data not found!"
            }
        } catch {
            isAlertActive = true
            alertMessage = (error as? NetworkError)?.description ?? "Network Error! Something went wrong"
            print(error)
        }
    }
    
    @MainActor
    func deleteFavorite(id: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result: FavoriteResponse = try await service.makeRequest(for: PetAPI.deleteFavorite(id: id))
            
            if result.message == "SUCCESS" {
                if let index = favorites.firstIndex(where: {$0.id == id}) {
                    favorites.remove(at: index)
                }
                removeFavoriteFromDefaults(id: id)
            } else {
                isAlertActive = true
                self.alertMessage = "Can't remove your favorite"
            }
            cart.removeAll(where: { $0.id == id })
        } catch {
            isAlertActive = true
            alertMessage = (error as? NetworkError)?.description ?? "Network Error! Something went wrong"
            print(error)
        }
    }
    
    func addToCart(of favorite: Favorite) {
        let isAlreadyAdded = cart.contains { $0.id == favorite.id }
        if !isAlreadyAdded {
            cart.append(favorite)
        } else {
            cart.removeAll(where: { $0.id == favorite.id })
        }
    }
    
    func refreshedTriggered() {
        favorites.removeAll()
    }
    
    private func removeFavoriteFromDefaults(id: Int) {
        var favorites = UserDefaults.standard.dictionary(forKey: "favorite_pet") ?? [:]
        if let index = favorites.firstIndex(where: { $0.key == String(id) }) {
            favorites.remove(at: index)
        }
        UserDefaults.standard.set(favorites, forKey: "favorite_pet")
    }
    
    private func getFavoriteFromDefaults() -> [String:Any] {
        return UserDefaults.standard.dictionary(forKey: "favorite_pet") ?? [:]
    }
}
