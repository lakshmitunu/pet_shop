//
//  PetDetailViewModel.swift
//  Pet Shop
//
//  Created by Lakshmi on 18/04/24.
//

import SwiftUI

class PetDetailViewModel: ObservableObject {
    @AppStorage("current_email") private var currentEmail = ""
    @Published private(set) var isLoading = false
    @Published private(set) var alertMessage: Message = .addFail
    @Published var isAlertActive = false
    
    private let apiService: APIService!
    
    init(apiService: APIService = APIServiceImpl.shared) {
        self.apiService = apiService
    }
    
    @MainActor
    func addToFavorite(pet: Pet) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result: FavoriteResponse = try await apiService.makeRequest(session: .shared, for: PetAPI.addFavorite(petId: pet.id, userId: currentEmail))
            isAlertActive = true
            if result.message == "SUCCESS" {
                self.alertMessage = .added
                addFavoriteToDefaults(id: result.id ?? 0, price: pet.price ?? 0)
            } else {
                self.alertMessage = .addFail
            }
        } catch {
            isAlertActive = true
            alertMessage = .networkError(message: (error as? NetworkError)?.description ?? "Network Error! Something went wrong")
            print(error)
        }
    }
    
    private func addFavoriteToDefaults(id: Int, price: Int) {
        var favorites = UserDefaults.standard.dictionary(forKey: "favorite_pet") ?? [:]
        let favorite = [String(id):price]
        favorites.merge(favorite, uniquingKeysWith: { $1 })
        UserDefaults.standard.set(favorites, forKey: "favorite_pet")
    }
}

extension PetDetailViewModel {
    enum Message: LocalizedError, Equatable {
        case added
        case addFail
        case networkError(message: String)
        
        var errorDescription: String? {
            switch self {
            case .added:
                return "Added to your favorite"
            case .addFail:
                return "Can't add to your favorite"
            case .networkError(message: let description):
                return description
            }
        }
    }
}
