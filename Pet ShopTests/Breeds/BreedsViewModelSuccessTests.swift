//
//  BreedsViewModelSuccessTests.swift
//  Pet ShopTests
//
//  Created by Ferry Dwianta P on 24/04/24.
//

import XCTest
@testable import Pet_Shop

final class BreedsViewModelSuccessTests: XCTestCase {

    private var serviceMock: APIService!
    private var viewModel: BreedsViewModel!
    
    override func setUp() {
        serviceMock = APIServiceBreedsResponseSuccessMock()
        viewModel = BreedsViewModel(apiService: serviceMock)
    }
    
    override func tearDown() {
        serviceMock = nil
        viewModel = nil
    }
    
    func test_with_successful_response_breeds_array_is_set() async throws {
        XCTAssertFalse(viewModel.isLoading, "View Model shouldn't load any data yet")
        defer {
            XCTAssertFalse(viewModel.isLoading, "View Model shouldn't be loading any data")
        }
        await viewModel.getBreedsData()
        XCTAssertEqual(viewModel.breeds.count, 10, "There should be 10 breeds data within breeds array")
        XCTAssertGreaterThan(viewModel.totalData, 0, "There should be more than zero of total pagination data")
    }

    func test_with_successful_paginated_response_users_array_is_set() async throws {
        XCTAssertFalse(viewModel.isLoading, "View Model shouldn't load any data yet")
        defer {
            XCTAssertFalse(viewModel.isLoading, "View Model shouldn't be loading any data")
        }
        
        await viewModel.getBreedsData()
        XCTAssertEqual(viewModel.breeds.count, 10, "There should be 10 breeds data within breeds array")
        XCTAssertGreaterThan(viewModel.totalData, 0, "There should be more than zero of total pagination data")
        
        await viewModel.getNextBreedsData()
        XCTAssertEqual(viewModel.breeds.count, 20, "There should be 20 breeds data within breeds array")
        XCTAssertEqual(viewModel.page, 1, "Page should be equal to 1")
    }
    
    func test_with_refresh_called_values_is_reset() async throws {
        XCTAssertFalse(viewModel.isLoading, "View Model shouldn't load any data yet")
        defer {
            XCTAssertFalse(viewModel.isLoading, "View Model shouldn't be loading any data")
        }
        
        await viewModel.getBreedsData()
        XCTAssertEqual(viewModel.breeds.count, 10, "There should be 10 breeds data within breeds array")
        XCTAssertGreaterThan(viewModel.totalData, 0, "There should be more than zero of total pagination data")
        
        await viewModel.getNextBreedsData()
        XCTAssertEqual(viewModel.breeds.count, 20, "There should be 20 breeds data within breeds array")
        XCTAssertEqual(viewModel.page, 1, "Page should be equal to 1")
        
        viewModel.refreshedTriggered()
        XCTAssertEqual(viewModel.breeds.count, 0, "There should be 0 breeds data within breeds array")
        XCTAssertEqual(viewModel.page, 0, "Page should be equal to 0")
        XCTAssertEqual(viewModel.totalData, 0, "There should be more than zero of total pagination data")
    }
    
    func test_with_last_breed_func_return_true() async {
        await viewModel.getBreedsData()
        
        let breeds = try! StaticJSONMapper.decode(file: "BreedsData", type: [Breed].self)
        
        let hasReachedEnd = viewModel.hasReachedEnd(of: breeds.last!)
        
        XCTAssertTrue(hasReachedEnd, "Last breed data should match")
    }
    
    func test_with_successful_pet_response_image_string_url_is_returned() async throws {
        let urlString = await viewModel.getBreedImageData(petId: "BJa4kxc4X")
        
        let pet = try! StaticJSONMapper.decode(file: "PetData", type: Pet.self)
        XCTAssertEqual(urlString, pet.url, "View Model should return the same url string")
    }
}
