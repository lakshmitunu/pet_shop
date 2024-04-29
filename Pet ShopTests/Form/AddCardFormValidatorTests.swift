//
//  AddCardFormValidatorTests.swift
//  Pet ShopTests
//
//  Created by Lakshmi on 23/04/24.
//

import XCTest
@testable import Pet_Shop

final class AddCardFormValidatorTests: XCTestCase {
    
    private var validator: CardValidator!
    
    override func setUp() {
        validator = CardValidatorImpl()
    }
    
    override func tearDown() {
        validator = nil
    }
    
    func test_with_empty_holder_name_error_thrown() {
        let card = CardPayment(holderName: "", number: "1111 2222 3333 4444", expMonth: "12", expYear: "24", ccv: "233")
        XCTAssertThrowsError(try validator.validate(card), "Error for empty holder name should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidHolderNameEmpty, "Expecting an error of invalid empty holder name")
        }
    }
    
    func test_with_empty_card_number_error_thrown() {
        let card = CardPayment(holderName: "John", number: "", expMonth: "12", expYear: "24", ccv: "233")
        XCTAssertThrowsError(try validator.validate(card), "Error for empty card number should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidCardNumberEmpty, "Expecting an error of invalid empty card number")
        }
    }
    
    func test_with_empty_exp_month_error_thrown() {
        let card = CardPayment(holderName: "John", number: "1111 2222 3333 4444", expMonth: "", expYear: "24", ccv: "233")
        XCTAssertThrowsError(try validator.validate(card), "Error for empty exp month number should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidExpMonthEmpty, "Expecting an error of invalid empty exp month number")
        }
    }
    
    func test_with_empty_exp_year_error_thrown() {
        let card = CardPayment(holderName: "John", number: "1111 2222 3333 4444", expMonth: "12", expYear: "", ccv: "233")
        XCTAssertThrowsError(try validator.validate(card), "Error for empty exp year number should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidExpYearEmpty, "Expecting an error of invalid empty exp year number")
        }
    }
    
    func test_with_empty_ccv_error_thrown() {
        let card = CardPayment(holderName: "John", number: "1111 2222 3333 4444", expMonth: "12", expYear: "24", ccv: "")
        XCTAssertThrowsError(try validator.validate(card), "Error for empty ccv number should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidCCVEmpty, "Expecting an error of invalid empty cvv number")
        }
    }
    
    func test_with_invalid_digit_card_number_error_thrown() {
        let card = CardPayment(holderName: "John", number: "1111 2222 3333", expMonth: "12", expYear: "24", ccv: "233")
        XCTAssertThrowsError(try validator.validate(card), "Error for invalid digit card number should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidCardNumberDigit, "Expecting an error of invalid digit card number")
        }
    }
    
    func test_with_invalid_digit_exp_month_error_thrown() {
        let card = CardPayment(holderName: "John", number: "1111 2222 3333 4444", expMonth: "2", expYear: "24", ccv: "233")
        XCTAssertThrowsError(try validator.validate(card), "Error for invalid digit exp month number should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidExpMonthDigit, "Expecting an error of invalid digit exp month number")
        }
    }
    
    func test_with_invalid_digit_exp_year_thrown() {
        let card = CardPayment(holderName: "John", number: "1111 2222 3333 4444", expMonth: "02", expYear: "4", ccv: "233")
        XCTAssertThrowsError(try validator.validate(card), "Error for invalid digit exp year number should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidExpYearDigit, "Expecting an error of invalid digit exp year number")
        }
    }
    
    func test_with_invalid_digit_ccv_error_thrown() {
        let card = CardPayment(holderName: "John", number: "1111 2222 3333 4444", expMonth: "02", expYear: "24", ccv: "23")
        XCTAssertThrowsError(try validator.validate(card), "Error for invalid digit ccv number should be thrown")
        
        do {
            _ = try validator.validate(card)
        } catch {
            guard let validatorError = error as? CardValidatorImpl.CardValidatoreError else {
                XCTFail("Wrong type of error, expecting card validation error")
                return
            }
            
            XCTAssertEqual(validatorError, CardValidatorImpl.CardValidatoreError.invalidCCVDigit, "Expecting an error of invalid digit ccv number")
        }
    }
    
    func test_with_valid_card_info_error_not_thrown() {
        let card = CardPayment(holderName: "John", number: "1111 2222 3333 4444", expMonth: "12", expYear: "24", ccv: "233")
        
        do {
            _ = try validator.validate(card)
        } catch {
            XCTFail("No errors should be thrown from valid card info")
        }
    }
}
