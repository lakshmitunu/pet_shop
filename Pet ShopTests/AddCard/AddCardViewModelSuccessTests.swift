//
//  AddViewModelSuccessTests.swift
//  Pet ShopTests
//
//  Created by Lakshmi on 24/04/24.
//

import XCTest
@testable import Pet_Shop

final class AddCardViewModelSuccessTests: XCTestCase {
    
    private var validationMock: CardValidator!
    private var viewModel: AddCardViewModel!
    
    override func setUp() {
        validationMock = AddCardValidatorSuccessMock()
        viewModel = AddCardViewModel(validator: validationMock)
    }
    
    override func tearDown() {
        validationMock = nil
        viewModel = nil
    }
    
    func test_with_valid_form_add_card_is_valid() async throws {
        let card = CardPayment()
        
        XCTAssertFalse(viewModel.isAllowSave)
        XCTAssertEqual(viewModel.alertMessage, "")
        XCTAssertFalse(viewModel.isAlertActive)
        defer {
            XCTAssertEqual(viewModel.alertMessage, "")
            XCTAssertFalse(viewModel.isAlertActive)
        }
        
        viewModel.saveCardInfo(with: card)
        
        XCTAssertTrue(viewModel.isAllowSave)
    }
}
