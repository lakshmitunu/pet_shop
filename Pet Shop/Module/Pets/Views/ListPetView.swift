//
//  ListPetView.swift
//  Pet Shop
//
//  Created by Lakshmi on 17/04/24.
//

import SwiftUI

struct ListPetView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel: ListPetViewModel
    @State private var hasAppeared = false
    
    let breed: Breed
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
    
    init(breed: Breed) {
        self.breed = breed
        #if DEBUG
        if UITestingHelper.isUITesting {
            let mock: APIService = UITestingHelper.isPetsNetworkingSuccessful ? APIServicePetsResponseSuccessMock() : APIServicePetsResponseFailureMock()
            _viewModel = StateObject(wrappedValue: ListPetViewModel(apiService: mock))
        } else {
            _viewModel = StateObject(wrappedValue: ListPetViewModel())
        }
        #else
            _viewModel = StateObject(wrappedValue: ListPetViewModel())
        #endif
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Browse through dogs!")
                                .foregroundColor(Color.textSecondaryColor)
                                .font(.system(size: 18)) +
                            
                            Text(" And mark your favorites ")
                                .foregroundColor(Color.appPrimaryColor)
                                .font(.system(size: 18, weight: .semibold)) +
                            
                            Text("for later purchase.")
                                .foregroundColor(Color.textSecondaryColor)
                                .font(.system(size: 18))
                            
                            Spacer()
                        }
                        .padding(.bottom, 16)
                        
                        LazyVGrid(columns: columns, spacing: 12) {
                            ForEach(viewModel.pets, id: \.id) { pet in
                                NavigationLink {
                                    PetDetailView(pet: pet)
                                } label: {
                                    PetCellView(pet: pet, cellWidth: (reader.size.width-46) / 2)
                                        .accessibilityIdentifier("item_\(pet.id)")
                                        .task {
                                            if viewModel.hasReachedEnd(of: pet) && !viewModel.isFetching{
                                                await viewModel.getNextPetsData(breedId: breed.id)
                                            }
                                        }
                                }
                            }
                        }
                        .accessibilityIdentifier("petsGrid")
                        .padding(.bottom, 16)
                    }
                }
                .scrollIndicators(.hidden)
                .refreshable {
                    viewModel.refreshedTriggered()
                    Task {
                        await viewModel.getPetsData(breedId: breed.id)
                    }
                }
                .overlay(alignment: .bottom) {
                    if viewModel.isFetching {
                        ProgressView()
                            .scaleEffect(1.4, anchor: .center)
                            .padding(.bottom, 34)
                    }
                }
                .alert(viewModel.alertMessage, isPresented: $viewModel.isAlertActive) {
                    Button("OK", role: .cancel) { }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
                
                if viewModel.pets.isEmpty && !viewModel.isLoading {
                    EmptyStateView()
                }
            }
            .navigationTitle(breed.name)
            .navigationBarTitleDisplayMode(.large)
            .padding(.horizontal, 16)
            .background(Color(colorScheme == .dark ? UIColor.systemBackground : UIColor.secondarySystemBackground))
            .ignoresSafeArea(edges: .bottom)
            .task {
                if !hasAppeared {
                    await viewModel.getPetsData(breedId: breed.id)
                    hasAppeared = true
                }
            }
        }
    }
}

//#Preview {
//    ListPetView(breed: Breed(weight: Size(imperial: "", metric: ""), height: Size(imperial: "", metric: ""), id: 1, name: "", lifeSpan: "", breedGroup: "", bredFor: "", origin: "", temperament: "", referenceImageID: ""))
//}


struct PetCellView: View {
    var pet: Pet
    let cellWidth: CGFloat
    
    var body: some View {
        ZStack {
            AsyncImageView(url: pet.url)
                .frame(width: cellWidth-16, height: 160, alignment: .center)
                .clipped()
                .cornerRadius(18)
                .padding(.top, 8)
                .padding(.bottom, 24)
            
            HStack {
                Text("$\(pet.price ?? 0)")
                    .foregroundColor(Color.white)
                    .font(.system(size: 13, weight: .medium))
            }
            .frame(width: 54, height: 26)
            .background(Color.appSecondaryColor)
            .cornerRadius(6)
            .offset(x: (cellWidth-100)/2, y: 70)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.cardBgColor)
        .cornerRadius(24)
    }
}

