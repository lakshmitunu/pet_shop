//
//  PetDetailViewModelSuccessTests.swift
//  Pet ShopTests
//
//  Created by Lakshmi on 24/04/24.
//

import XCTest
@testable import Pet_Shop

final class PetDetailViewModelSuccessTests: XCTestCase {
    
    private var serviceMock: APIService!
    private var viewModel: PetDetailViewModel!
    
    override func setUp() {
        serviceMock = APIServiceAddFavoriteResponseSuccessMock()
        viewModel = PetDetailViewModel(apiService: serviceMock)
    }
    
    override func tearDown() {
        serviceMock = nil
        viewModel = nil
    }
    
    func test_with_successful_response_add_favorite_is_added() async throws {
        let pet = Pet(id: "BJa4kxc4X", url: "", breeds: nil, width: nil, height: nil)
        
        XCTAssertFalse(viewModel.isLoading, "View Model shouldn't be loading any data")
        defer {
            XCTAssertFalse(viewModel.isLoading, "View Model shouldn't be loading any data")
        }
        
        await viewModel.addToFavorite(pet: pet)
        
        XCTAssertTrue(viewModel.isAlertActive)
        XCTAssertEqual(viewModel.alertMessage, .added)
    }
}
