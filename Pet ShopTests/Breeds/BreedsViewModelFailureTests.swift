//
//  BreedsViewModelFailureTests.swift
//  Pet ShopTests
//
//  Created by Ferry Dwianta P on 24/04/24.
//

import XCTest
@testable import Pet_Shop

final class BreedsViewModelFailureTests: XCTestCase {

    private var serviceMock: APIService!
    private var viewModel: BreedsViewModel!
    
    override func setUp() {
        serviceMock = APIServiceBreedsResponseFailureMock()
        viewModel = BreedsViewModel(apiService: serviceMock)
    }
    
    override func tearDown() {
        serviceMock = nil
        viewModel = nil
    }
    
    func test_with_unsuccessful_response_error_is_handled() async {
        XCTAssertFalse(viewModel.isLoading, "View Model shouldn't load any data yet")
        defer {
            XCTAssertFalse(viewModel.isLoading, "View Model shouldn't be loading any data")
        }
        
        await viewModel.getBreedsData()
        
        XCTAssertTrue(viewModel.isAlertActive, "View Model should have an error")
        XCTAssertNotEqual(viewModel.alertMessage, "", "View Model should have an error message")
    }
}
