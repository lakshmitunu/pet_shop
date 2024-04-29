//
//  CheckoutViewModel.swift
//  Pet Shop
//
//  Created by Lakshmi on 20/04/24.
//

import Foundation

class CheckoutDetailViewModel: ObservableObject {
    @Published private(set) var totalPrice = 0
    @Published private(set) var totalTax: Double = 0
    @Published private(set) var totalFee: Double = 0
    @Published private(set) var isLoading = false
    @Published private(set) var alertMessage = ""
    @Published var isAlertActive = false
    
    private var service = APIServiceImpl()
    
    func calculatePayment(cart: [Favorite]) {
        let total = cart.reduce(0) { $0 + ($1.pet.price ?? 0) }
        let tax = Double(total)*0.10
        let fee = Double(total)*0.02
        totalPrice = total
        totalTax = tax
        totalFee = fee
    }
    
    @MainActor
    func getBreedNameData(petId: String) async -> String {
        do {
            let result: Pet = try await service.makeRequest(for: PetAPI.pet(petId: petId))
            return result.breeds?[0].name ?? "-"
        } catch {
            isAlertActive = true
            alertMessage = (error as? NetworkError)?.description ?? "Network Error! Something went wrong"
            print(error)
            return ""
        }
    }
}
