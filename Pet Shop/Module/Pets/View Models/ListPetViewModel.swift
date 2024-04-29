//
//  ListPetViewModel.swift
//  Pet Shop
//
//  Created by Lakshmi on 18/04/24.
//

import Foundation

class ListPetViewModel: ObservableObject {
    @Published private(set) var pets = [Pet]()
    @Published private(set) var isLoading = false
    @Published private(set) var isFetching = false
    @Published private(set) var alertMessage = ""
    @Published var isAlertActive = false
    
    private let apiService: APIService!
    private(set) var page = 0
    private(set) var totalData = 0
    
    init(apiService: APIService = APIServiceImpl.shared) {
        self.apiService = apiService
    }
    
    @MainActor
    func getPetsData(breedId: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            var result: (data: [Pet], paginationCount: Int) = try await apiService.makeRequest(session: .shared, for: PetAPI.pets(breedId: breedId, page: page))
            
            for (index, _) in result.data.enumerated() {
                result.data[index].price = Int.random(in: 50...200)
            }

            self.pets = result.data
            self.totalData = result.paginationCount
        } catch {
            isAlertActive = true
            alertMessage = (error as? NetworkError)?.description ?? "Network Error! Something went wrong"
            print(error)
        }
    }
    
    @MainActor
    func getNextPetsData(breedId: Int) async {
        guard !(pets.count >= totalData) else {
            return
        }
        
        isFetching = true
        defer { isFetching = false }
        
        page += 1
        
        do {
            var result: [Pet] = try await apiService.makeRequest(session: .shared, for: PetAPI.pets(breedId: breedId, page: page))
            
            for (index, _) in result.enumerated() {
                result[index].price = Int.random(in: 50...200)
            }
            
            // Prevent duplicate data
            for pet in result {
                if !petExists(withId: pet.id) {
                    pets.append(pet)
                }
            }
        } catch {
            isAlertActive = true
            alertMessage = (error as? NetworkError)?.description ?? "Network Error! Something went wrong"
            print(error)
        }
    }
    
    func hasReachedEnd(of pet: Pet) -> Bool {
        pets.last?.id == pet.id
    }
    
    func refreshedTriggered() {
        pets.removeAll()
        page = 0
        totalData = 0
    }
    
    private func petExists(withId id: String) -> Bool {
        return pets.contains(where: { $0.id == id })
    }
}
