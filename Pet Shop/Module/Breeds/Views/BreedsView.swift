//
//  ContentView.swift
//  Pet Shop
//
//  Created by Lakshmi on 16/04/24.
//

import SwiftUI

struct BreedsView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel: BreedsViewModel
    @State private var hasAppeared = false
    
    init() {
        #if DEBUG
        if UITestingHelper.isUITesting {
            let mock: APIService = UITestingHelper.isBreedsNetworkingSuccessful ? APIServiceBreedsResponseSuccessMock() : APIServiceBreedsResponseFailureMock()
            _viewModel = StateObject(wrappedValue: BreedsViewModel(apiService: mock))
        } else {
            _viewModel = StateObject(wrappedValue: BreedsViewModel())
        }
        #else
            _viewModel = StateObject(wrappedValue: BreedsViewModel())
        #endif
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Find your perfect match!")
                            .foregroundColor(Color.textSecondaryColor)
                            .font(.system(size: 18)) +
                        
                        Text(" Choose a dog breed ")
                            .foregroundColor(Color.appPrimaryColor)
                            .font(.system(size: 18, weight: .semibold)) +

                        Text("to explore available companions.")
                            .foregroundColor(Color.textSecondaryColor)
                            .font(.system(size: 18))
                        
                        Spacer()
                    }
                    .padding(.bottom, 16)
                    
                    LazyVStack {
                        ForEach(viewModel.breeds, id: \.id) { breed in
                            NavigationLink {
                                ListPetView(breed: breed)
                            } label: {
                                BreedCellView(breed: breed, viewModel: viewModel)
                                    .accessibilityIdentifier("item_\(breed.id)")
                                    .task {
                                        if viewModel.hasReachedEnd(of: breed) && !viewModel.isFetching{
                                            await viewModel.getNextBreedsData()
                                        }
                                    }
                            }
                        }
                    }
                    .accessibilityIdentifier("breedsVStack")
                }
            }
            .padding(.horizontal, 16)
            .scrollIndicators(.hidden)
            .refreshable {
                viewModel.refreshedTriggered()
                Task {
                    await viewModel.getBreedsData()
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
            
            if viewModel.breeds.isEmpty && !viewModel.isLoading {
                EmptyStateView()
            }
        }
        .background(Color(colorScheme == .dark ? UIColor.systemBackground : UIColor.secondarySystemBackground))
        .task {
            if !hasAppeared {
                await viewModel.getBreedsData()
                hasAppeared = true
            }
        }
    }
}

//#Preview {
//    BreedsView()
//}

struct BreedCellView: View {
    var breed: Breed
    var viewModel: BreedsViewModel
    
    @State private var imageUrl = ""
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(breed.name)
                    .font(.custom("LeckerliOne-Regular", size: 20))
                    .lineLimit(2)
                    .foregroundColor(Color.textPrimaryColor)
                    .multilineTextAlignment(.leading)
                    .padding(.top, 12)
                
                Text(breed.temperament)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.textSecondaryColor)
                    .lineLimit(4)
                    .multilineTextAlignment(.leading)
                Spacer()
                HStack {
                    Image("scale")
                    Text("\(breed.weight.imperial) lbs")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.textSecondaryColor)
                }
                .padding(.bottom, 12)
            }
            .padding(12)
            
            Spacer()
            
            AsyncImageView(url: imageUrl)
                .frame(width: 140, height: 150, alignment: .center)
                .clipped()
                .cornerRadius(20)
                .padding(12)
        }
        .task {
            imageUrl = await viewModel.getBreedImageData(petId: breed.referenceImageID)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.cardBgColor)
        .cornerRadius(24)
        .padding(.bottom, 12)
    }
}
