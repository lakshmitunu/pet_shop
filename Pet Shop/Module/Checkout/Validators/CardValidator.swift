//
//  CardValidator.swift
//  Pet Shop
//
//  Created by Lakshmi on 23/04/24.
//

import Foundation

protocol CardValidator {
    func validate(_ card: CardPayment) throws
}

struct CardValidatorImpl: CardValidator {
    func validate(_ card: CardPayment) throws {
        if card.holderName.isEmpty {
            throw CardValidatoreError.invalidHolderNameEmpty
        }
        
        if card.number.isEmpty {
            throw CardValidatoreError.invalidCardNumberEmpty
        }
        
        if card.expMonth.isEmpty {
            throw CardValidatoreError.invalidExpMonthEmpty
        }
        
        if card.expYear.isEmpty {
            throw CardValidatoreError.invalidExpYearEmpty
        }
        
        if card.ccv.isEmpty {
            throw CardValidatoreError.invalidCCVEmpty
        }
        
        if card.number.count != 19 {
            throw CardValidatoreError.invalidCardNumberDigit
        }
        
        if card.expMonth.count != 2 {
            throw CardValidatoreError.invalidExpMonthDigit
        }
        
        if card.expYear.count != 2 {
            throw CardValidatoreError.invalidExpYearDigit
        }
        
        if card.ccv.count != 3 {
            throw CardValidatoreError.invalidCCVDigit
        }
    }
}

extension CardValidatorImpl {
    enum CardValidatoreError: LocalizedError {
        case invalidHolderNameEmpty
        case invalidCardNumberEmpty
        case invalidExpMonthEmpty
        case invalidExpYearEmpty
        case invalidCCVEmpty
        case invalidCardNumberDigit
        case invalidExpMonthDigit
        case invalidExpYearDigit
        case invalidCCVDigit
    }
}

extension CardValidatorImpl.CardValidatoreError {
    var errorDescription: String? {
        switch self {
        case .invalidHolderNameEmpty:
            return "Holder name can't be empty"
        case .invalidCardNumberEmpty:
          return "Card Number can't be empty"
        case .invalidExpMonthEmpty:
          return "Expired month can't be empty"
        case .invalidExpYearEmpty:
          return "Expired year can't be empty"
        case .invalidCCVEmpty:
          return "CCV can't be empty"
        case .invalidCardNumberDigit:
          return "Card Number must be 16 digits"
        case .invalidExpMonthDigit:
          return "Expire Month must be 2 digits"
        case .invalidExpYearDigit:
          return "Expire Year must be 2 digits"
        case .invalidCCVDigit:
          return "CCV must be 3 digits"
        }
    }
}
