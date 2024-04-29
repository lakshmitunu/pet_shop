//
//  PetDetailViewModelFailureTests.swift
//  Pet ShopTests
//
//  Created by Lakshmi on 24/04/24.
//

import XCTest
@testable import Pet_Shop

final class PetDetailViewModelFailureTests: XCTestCase {
    private var serviceMock: APIService!
    private var viewModel: PetDetailViewModel!
    
    override func setUp() {
        serviceMock = APIServiceAddFavoriteResponseFailureMock()
        viewModel = PetDetailViewModel(apiService: serviceMock)
    }
    
    override func tearDown() {
        serviceMock = nil
        viewModel = nil
    }

    func test_with_unsuccessful_response_error_is_handled() async {
        let pet = Pet(id: "BJa4kxc4X", url: "", breeds: nil, width: nil, height: nil)
        
        XCTAssertFalse(viewModel.isLoading, "View Model shouldn't be loading any data")
        defer {
            XCTAssertFalse(viewModel.isLoading, "View Model shouldn't be loading any data")
        }
        
        await viewModel.addToFavorite(pet: pet)
        
        XCTAssertTrue(viewModel.isAlertActive, "View Model alert should be active")
        XCTAssertEqual(viewModel.alertMessage, .networkError(message: NetworkError.serverError(statusCode: 404).description), "View Model message should return network error of server error with 404 status code")
    }
}
