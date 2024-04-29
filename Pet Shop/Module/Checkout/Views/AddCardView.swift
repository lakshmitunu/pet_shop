//
//  AddCardView.swift
//  Pet Shop
//
//  Created by Lakshmi on 20/04/24.
//

import SwiftUI

enum CardFocusedField {
    case name
    case number
    case expiryDate
    case ccv
}

struct AddCardView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var checkoutCardInfo: CardPayment
    @FocusState private var focusedField: CardFocusedField?
    @State private var cardInfo: CardPayment = CardPayment()
    
    @StateObject private var viewModel = AddCardViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Card Holder's Name", text: $cardInfo.holderName)
                    .textContentType(.name)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .name)
                    .padding()
                    .background(Color.textfieldBgColor)
                    .cornerRadius(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(focusedField == .name ? Color.appPrimaryColor : .clear, lineWidth: 2)
                    )
                    .padding(.top, 16)
                
                TextField("Card Number", text: $cardInfo.number)
                    .keyboardType(.numberPad)
                    .textContentType(.creditCardNumber)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
                    .focused($focusedField, equals: .number)
                    .padding()
                    .background(Color.textfieldBgColor)
                    .cornerRadius(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(focusedField == .number ? Color.appPrimaryColor : .clear, lineWidth: 2)
                    )
                    .padding(.top, 16)
                    .onChange(of: cardInfo.number) { newValue in
                        let cleanedText = newValue.filter { $0.isNumber }
                        if cleanedText.count > 16 {
                            cardInfo.number = String(cleanedText.prefix(16))
                            return
                        }
                        let formattedText = cleanedText.separated(by: " ", stride: 4)
                        cardInfo.number = formattedText
                    }
                
                HStack {
                    HStack {
                        Spacer()
                        TextField("08", text: $cardInfo.expMonth)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .textContentType(.dateTime)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .expiryDate)
                            .padding(.vertical)
                            .padding(.leading)
                            .onChange(of: cardInfo.expMonth) { newValue in
                                let cleanedText = newValue.filter { $0.isNumber }
                                if cleanedText.count > 2 {
                                    cardInfo.expMonth = String(cleanedText.prefix(2))
                                    return
                                }
                                cardInfo.expMonth = cleanedText
                            }
                        
                        Text("/")
                            .font(.title3)
                        
                        TextField("24", text: $cardInfo.expYear)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .textContentType(.dateTime)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .expiryDate)
                            .padding(.vertical)
                            .padding(.trailing)
                            .onChange(of: cardInfo.expYear) { newValue in
                                let cleanedText = newValue.filter { $0.isNumber }
                                if cleanedText.count > 2 {
                                    cardInfo.expYear = String(cleanedText.prefix(2))
                                    return
                                }
                                cardInfo.expYear = cleanedText
                            }
                        Spacer()
                    }
                    .background(Color.textfieldBgColor)
                    .cornerRadius(16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(focusedField == .expiryDate ? Color.appPrimaryColor : .clear, lineWidth: 2)
                    )
                    .padding(.top, 16)
                    .padding(.trailing, 16)
                    
                    TextField("CCV", text: $cardInfo.ccv)
                        .keyboardType(.numberPad)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .ccv)
                        .padding()
                        .background(Color.textfieldBgColor)
                        .cornerRadius(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(focusedField == .ccv ? Color.appPrimaryColor : .clear, lineWidth: 2)
                        )
                        .padding(.top, 16)
                        .onChange(of: cardInfo.ccv) { newValue in
                            let cleanedText = newValue.filter { $0.isNumber }
                            if cleanedText.count > 3 {
                                cardInfo.ccv = String(cleanedText.prefix(3))
                                return
                            }
                            cardInfo.ccv = cleanedText
                        }
                }
                
                Spacer()
            }
            .alert(viewModel.alertMessage, isPresented: $viewModel.isAlertActive) {
                Button("OK", role: .cancel) { }
            }
            .navigationTitle("Card Info")
            .navigationBarTitleDisplayMode(.large)
            .padding(.horizontal, 16)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveCardInfo(with: cardInfo)
                        if viewModel.isAllowSave {
                            checkoutCardInfo = cardInfo
                            dismiss()
                        }
                    }
                }
            }
            .onAppear {
                if !checkoutCardInfo.holderName.isEmpty {
                    cardInfo = checkoutCardInfo
                }
            }
        }
    }
}
