//
//  AddCardValidatorSuccessMock.swift
//  Pet ShopTests
//
//  Created by Lakshmi on 24/04/24.
//

#if DEBUG
import Foundation

class AddCardValidatorSuccessMock: CardValidator {
    func validate(_ card: Pet_Shop.CardPayment) throws {}
}
#endif
