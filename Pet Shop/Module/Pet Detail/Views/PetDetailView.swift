//
//  PetDetailView.swift
//  Pet Shop
//
//  Created by Lakshmi on 18/04/24.
//

import SwiftUI

struct PetDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = PetDetailViewModel()
    let pet: Pet

    var body: some View {
        GeometryReader { reader in
            ZStack {
                ScrollView {
                    VStack {
                        AsyncImageView(url: pet.url)
                            .frame(width: reader.size.width, height: reader.size.height / 2)
                            .roundedCorner(34, corners: [.bottomLeft, .bottomRight])
                            .padding(.horizontal, -16)

                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(pet.breeds?[0].name ?? " ")")
                                    .font(.custom("LeckerliOne-Regular", size: 20))
                                    .fontWeight(.semibold)

//                              HStack {
//                                  let petOrigins: String
//                                  if let origin = pet.breeds?[0].origin {
//                                      petOrigins = origin.isEmpty ? "-" : origin
//                                  } else {
//                                      petOrigins = "-"
//                                  }
//                                  Image("location")
//                                  Text(petOrigins)
//                                      .font(.system(size: 16))
//                                      .foregroundColor(Color.textSecondaryColor)
//                              }
                                HStack {
                                  let petOrigins: String = pet.breeds?[0].origin ?? "-"
                                  Image("location")
                                  Text(petOrigins)
                                      .font(.system(size: 16))
                                      .foregroundColor(Color.textSecondaryColor)
                              }
                            }
                            .padding(.vertical, 16)
                            .padding(.leading, 16)

                            Spacer()

                            Text("$\(pet.price ?? 0)")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(Color.appSecondaryColor)
                                .padding(.trailing, 16)
                        }
                        .frame(width: reader.size.width <= 0 ? 0 : reader.size.width-32)
                        .background(Color.cardBgColor)
                        .cornerRadius(20)
                        .padding(.top, -50)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Details")
                                .font(.custom("LeckerliOne-Regular", size: 18))
                                .fontWeight(.medium)

//                            HStack {
//                                Text("\(pet.breeds?[0].name ?? " ") dog can reach height between")
//                                    .foregroundColor(Color.textSecondaryColor) +
//
//                                Text(" \(pet.breeds?[0].height.imperial ?? "-") inches")
//                                    .fontWeight(.medium)
//                                    .foregroundColor(Color.appPrimaryColor) +
//
//                                Text(", and weight between")
//                                    .foregroundColor(Color.textSecondaryColor) +
//                                    .foregroundColor(Color.textSecondaryColor) +
//
//                                Text(" \(pet.breeds?[0].weight.imperial ?? "-") lbs")
//                                    .fontWeight(.medium)
//                                    .foregroundColor(Color.appPrimaryColor) +
//
//                                Text(". Here are more details about this dog:")
//                                    .foregroundColor(Color.textSecondaryColor)
//                            }

                            .font(.system(size: 16))
                            .padding(.bottom, 16)

                            HStack(spacing: 12) {
                                let cellWidth = (reader.size.width - 32 - 24) / 3

                                DetailCellView(data: "\(pet.breeds?[0].lifeSpan.dropLast(5) ?? "-")", desctiption: "Age", cellWidth: cellWidth)

                                DetailCellView(data: "\((pet.width ?? 0) / 100) inch", desctiption: "Width", cellWidth: cellWidth)

                                DetailCellView(data: "\((pet.height ?? 0) / 100) inch", desctiption: "Height", cellWidth: cellWidth)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Temprament")
                                .font(.custom("LeckerliOne-Regular", size: 18))
                                .fontWeight(.medium)
                            Text(pet.breeds?[0].temperament ?? "-")
                                .font(.system(size: 16))
                                .foregroundColor(Color.textSecondaryColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Breed For")
                                .font(.custom("LeckerliOne-Regular", size: 18))
                                .fontWeight(.medium)
                            Text(pet.breeds?[0].bredFor ?? "-")
                                .font(.system(size: 16))
                                .foregroundColor(Color.textSecondaryColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 16)
                        .padding(.bottom, 90)
                    }
                    .padding(.horizontal, 16)
                }
                .scrollIndicators(.hidden)

                VStack {
                    Spacer()
                    Button {
                        Task {
                            await viewModel.addToFavorite(pet: pet)
                        }
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Add to Favorite")
                        }
                    }
                    .padding(.bottom, 12)
                    .padding(.horizontal, 16)
                    .buttonStyle(PrimaryButton())
                }

                if viewModel.isLoading {
                    LoadingView()
                }
            }
            .background(Color(colorScheme == .dark ? UIColor.systemBackground : UIColor.secondarySystemBackground))
            .ignoresSafeArea(edges: .top)
            .alert(viewModel.alertMessage.localizedDescription, isPresented: $viewModel.isAlertActive) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

//#Preview {
//    PetDetailView(pet: Pet(id: "BJa4kxc4X", url: "https://cdn2.thedogapi.com/images/BJa4kxc4X_1280.jpg", breeds: [Breed(weight: Size(imperial: "6 - 13", metric: ""), height: Size(imperial: "9 - 11.5", metric: ""), id: 1, name: "American bull", lifeSpan: "10 - 12 years", breedGroup: "", bredFor: "Small rodent hunting, lapdog", origin: "Germany, France", temperament: "Stubborn, Curious, Playful, Adventurous, Active, Fun-loving", referenceImageID: "")], width: 1600, height: 1199))
//}

struct DetailCellView: View {
    let data: String
    let desctiption: String
    let cellWidth: CGFloat
    
    var body: some View {
        ZStack {
            Image(systemName: "pawprint.fill")
                .foregroundColor(Color.textSecondaryColor.opacity(0.07))
                .font(.system(size: 50))
                .rotationEffect(Angle(degrees: -30))
                .offset(x: 33, y: 21)
            
            VStack(spacing: 4) {
                Text(data)
                    .font(.system(size: 16, weight: .medium))
                
                Text(desctiption)
                    .font(.system(size: 14))
                    .foregroundColor(Color.textSecondaryColor)
            }
        }
        .frame(width: cellWidth <= 0 ? 0 : cellWidth, height: 80)
        .background(Color.cardBgColor)
        .cornerRadius(12)
    }
}
