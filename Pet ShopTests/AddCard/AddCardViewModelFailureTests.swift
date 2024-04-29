//
//  AddCardViewModelFailureTests.swift
//  Pet ShopTests
//
//  Created by Lakshmi on 24/04/24.
//

import XCTest
@testable import Pet_Shop

final class AddCardViewModelFailureTests: XCTestCase {
    private var validationMock: CardValidator!
    private var viewModel: AddCardViewModel!
    
    override func setUp() {
        validationMock = AddCardValidatorFailureMock()
        viewModel = AddCardViewModel(validator: validationMock)
    }
    
    override func tearDown() {
        validationMock = nil
        viewModel = nil
    }
    
    func test_with_invalid_form_add_card_is_invalid() async throws {
        let card = CardPayment()
        
        XCTAssertFalse(viewModel.isAllowSave)
        XCTAssertEqual(viewModel.alertMessage, "")
        XCTAssertFalse(viewModel.isAlertActive)
        
        viewModel.saveCardInfo(with: card)
        
        XCTAssertFalse(viewModel.isAllowSave)
        XCTAssertEqual(viewModel.alertMessage, CardValidatorImpl.CardValidatoreError.invalidHolderNameEmpty.localizedDescription)
        XCTAssertTrue(viewModel.isAlertActive)
    }
}
