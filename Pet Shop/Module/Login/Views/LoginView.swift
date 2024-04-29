//
//  LoginView.swift
//  Pet Shop
//
//  Created by Lakshmi on 16/04/24.
//

import SwiftUI

enum FocusedField {
    case email
    case password
    case confirmPassword
}

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var emailText = ""
    @State private var passwordText = ""
    @State private var confirmPasswordText = ""
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image("dog")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 230)
                        .padding(.leading, -20)
                        .padding(.top, 30)
                    Spacer()
                }
                Spacer()
            }
            
            VStack {
                Spacer()
                
                VStack {
                    Text(viewModel.title)
                        .foregroundColor(Color.appPrimaryColor)
                        .font(.custom("LeckerliOne-Regular", size: 32))
                        .fontWeight(.semibold)
                        .padding(.bottom, 1)
                        .padding(.top, 40)
                    
                    TextField("Email", text: $emailText)
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .email)
                        .padding()
                        .background(Color.textfieldBgColor)
                        .cornerRadius(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(focusedField == .email ? Color.appPrimaryColor : .clear, lineWidth: 2)
                        )
                        .padding(.top, 34)
                        .padding(.horizontal, 16)
                        .accessibilityIdentifier("emailTextField")
                    
                    SecureField("Password", text: $passwordText)
                        .textContentType(.password)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .focused($focusedField, equals: .password)
                        .padding()
                        .background(Color.textfieldBgColor)
                        .cornerRadius(16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(focusedField == .password ? Color.appPrimaryColor : .clear, lineWidth: 2)
                        )
                        .padding(.top, 16)
                        .padding(.horizontal, 16)
                        .accessibilityIdentifier("passwordTextField")
                    
                    if !viewModel.isUserHasAccount {
                        SecureField("Comfirm Password", text: $confirmPasswordText)
                            .textContentType(.newPassword)
                            .disableAutocorrection(true)
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .confirmPassword)
                            .padding()
                            .background(Color.textfieldBgColor)
                            .cornerRadius(16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(focusedField == .confirmPassword ? Color.appPrimaryColor : .clear, lineWidth: 2)
                            )
                            .padding(.top, 16)
                            .padding(.horizontal, 16)
                            .accessibilityIdentifier("confirmPasswordTextField")
                    }
                    
                    Button(viewModel.buttonTitle) {
                        viewModel.logInSignUpClicked(email: emailText, password: passwordText, confirmPassword: confirmPasswordText)
                    }
                    .accessibilityIdentifier("logInButton")
                    .buttonStyle(PrimaryButton())
                    .padding(.top, 60)
                    .padding(.bottom, 12)
                    .padding(.horizontal, 16)
                    
                    HStack {
                        Spacer()
                        Text(viewModel.haveAccountMessage)
                            .foregroundColor(Color.textSecondaryColor)
                            .font(.body)
                        
                        Button {
                            viewModel.haveAccountClicked()
                        } label: {
                            Text(viewModel.haveAccountButton)
                                .font(.body)
                                .fontWeight(.semibold)
                        }
                        .accessibilityIdentifier("haveAccountButton")
                        .alert(viewModel.alertMessage, isPresented: $viewModel.isAlertActive) {
                            Button("OK", role: .cancel) { }
                        }
                        Spacer()
                    }
                    .padding(.bottom, 40)
                    .padding(.horizontal, 16)
                }
                .background(Color(UIColor.systemBackground))
                .roundedCorner(30, corners: [.topLeft, .topRight])
            }
        }
        .background(Color.mainBgColor)
        .ignoresSafeArea(edges: .bottom)
        .navigationDestination(isPresented: $viewModel.isNavigate) {
            MainView()
        }
    }
}

//#Preview {
//    LoginView()
//}
