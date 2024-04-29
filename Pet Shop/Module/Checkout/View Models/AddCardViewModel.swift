//
//  AddCardViewModel.swift
//  Pet Shop
//
//  Created by Lakshmi on 23/04/24.
//

import Foundation

class AddCardViewModel: ObservableObject {
    @Published var alertMessage = ""
    @Published var isAlertActive = false
    @Published var isAllowSave = false
    
    private let validator: CardValidator!
    
    init(validator: CardValidator = CardValidatorImpl()) {
        self.validator = validator
    }
    
    func saveCardInfo(with card: CardPayment) {
        do {
            try validator.validate(card)
            isAllowSave = true
        } catch {
            isAlertActive = true
            alertMessage = (error as! CardValidatorImpl.CardValidatoreError).localizedDescription
        }
    }
}
