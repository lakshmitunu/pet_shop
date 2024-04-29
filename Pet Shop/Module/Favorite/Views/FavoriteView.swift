//
//  FavoriteView.swift
//  Pet Shop
//
//  Created by Lakshmi on 18/04/24.
//

import SwiftUI

struct FavoriteView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Int
    @StateObject private var viewModel = FavoriteViewModel()
    @State private var isNavigateToCheckout = false
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Ready to bring home your favorites?")
                                .foregroundColor(Color.textSecondaryColor)
                                .font(.system(size: 18)) +
                            
                            Text(" Add dogs to your cart ")
                                .foregroundColor(Color.appPrimaryColor)
                                .font(.system(size: 18, weight: .semibold)) +
                            
                            Text("for easy checkout.")
                                .foregroundColor(Color.textSecondaryColor)
                                .font(.system(size: 18))
                            
                            Spacer()
                        }
                        .padding(.bottom, 16)
                        
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.favorites, id: \.id) { favorite in
                                FavoriteCellView(favorite: favorite, cellWidth: (reader.size.width-46) / 2, deleteAction: {
                                    Task {
                                        await viewModel.deleteFavorite(id: favorite.id)
                                    }
                                }, addToCartAction: {
                                    viewModel.addToCart(of: favorite)
                                })
                            }
                        }
                        .padding(.bottom, 78)
                    }
                }
                .padding(.horizontal, 16)
                .scrollIndicators(.hidden)
                .refreshable {
                    viewModel.refreshedTriggered()
                    Task {
                        await viewModel.getFavoritesData()
                    }
                }
                .alert(viewModel.alertMessage, isPresented: $viewModel.isAlertActive) {
                    Button("OK", role: .cancel) { }
                }
                
                if !viewModel.cart.isEmpty {
                    VStack {
                        Spacer ()
                        Button("Checkout (\(viewModel.cart.count))") {
                            isNavigateToCheckout.toggle()
                        }
                        .buttonStyle(PrimaryButton())
                        .padding(.bottom, 12)
                        .padding(.horizontal, 16)
                    }
                }
                
                if viewModel.favorites.isEmpty && !viewModel.isLoading {
                    VStack {
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .padding(.bottom, 8)
                            .foregroundColor(.gray.opacity(0.5))
                        Text("Add your favorite pets here! \nAnd take them home with a tap")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                    }
                }
                
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .background(Color(colorScheme == .dark ? UIColor.systemBackground : UIColor.secondarySystemBackground))
            .task {
                await viewModel.getFavoritesData()
            }
            .navigationDestination(isPresented: $isNavigateToCheckout) {
                CheckoutDetailView(delegate: self, cart: viewModel.cart)
            }
        }
    }
}

extension FavoriteView: CheckoutDetailViewDelegate {
    func didCheckoutComplete(for cart: [Favorite]) {
        Task {
            for item in cart {
                await viewModel.deleteFavorite(id: item.id)
            }
            selectedTab = 0
        }
    }
}

//#Preview {
//    FavoriteView(selectedTab: .constant(1))
//}

struct FavoriteCellView: View {
    @State private var isAddedToCart = false
    
    var favorite: Favorite
    let cellWidth: CGFloat
    var deleteAction: (() -> Void)? = nil
    var addToCartAction: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            VStack {
                AsyncImageView(url: favorite.pet.url)
                    .frame(width: cellWidth-16, height: 160, alignment: .center)
                    .clipped()
                    .cornerRadius(18)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                
                HStack {
                    Button {
                        deleteAction?()
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                    }
                    .frame(width: (cellWidth-16) * 0.25, height: 32)
                    .background(Color.clear)
                    .foregroundColor(Color.appPrimaryColor)
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.appPrimaryColor, lineWidth: 1)
                    )
                    
                    Button(isAddedToCart == false ? "Add to Cart" : "Remove") {
                        isAddedToCart.toggle()
                        addToCartAction?()
                    }
                    .frame(width: (cellWidth-16) * 0.7, height: 32)
                    .font(.system(size: 14, weight: .semibold))
                    .background(isAddedToCart == false ? Color.accentColor : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }
                .padding(.bottom, 12)
            }
            
            Text("$\(favorite.pet.price ?? 0)")
                .foregroundColor(Color.white)
                .font(.system(size: 16, weight: .bold))
                .frame(width: 54, height: 26)
                .shadow(color: .black, radius: 5)
                .offset(x: (cellWidth-80)/2, y: -85)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(Color.cardBgColor)
        .background(isAddedToCart == false ? Color.cardBgColor : Color.appPrimaryColor.opacity(0.5))
        .cornerRadius(24)
    }
}
