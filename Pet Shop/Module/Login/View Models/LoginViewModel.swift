//
//  LoginViewModel.swift
//  Pet Shop
//
//  Created by Lakshmi on 16/04/24.
//

import SwiftUI
import Security

class LoginViewModel: ObservableObject {
    @Published private(set) var buttonTitle = "Log In"
    @Published private(set) var haveAccountMessage = "Don't have an account?"
    @Published private(set) var title = "Login To Your Account"
    @Published private(set) var haveAccountButton = "Sign Up"
    @Published private(set) var alertMessage = ""
    @Published private(set) var isUserHasAccount = true
    @Published var isAlertActive = false
    @Published var isNavigate = false
    @AppStorage("current_email") private var currentEmail = "test@gmail.com"
    
    private let validator: LoginValidator!
    
    init(validator: LoginValidator = LoginValidatorImpl()) {
        self.validator = validator
    }
    
    func haveAccountClicked() {
        isUserHasAccount.toggle()
        
        if isUserHasAccount {
            buttonTitle = "Log In"
            haveAccountMessage = "Don't have an account?"
            haveAccountButton = "Sign Up"
            title = "Login To Your Account"
        } else {
            buttonTitle = "Sign Up"
            haveAccountMessage = "Already have an account?"
            haveAccountButton = "Log In"
            title = "Create Your Account"
        }
    }
    
    func logInSignUpClicked(email: String, password: String, confirmPassword: String) {
        
        #if DEBUG
        if UITestingHelper.isUITesting {
            isNavigate = true
            return
        }
        #endif
        
        if !isUserHasAccount {
            do {
                try validator.validateSignUp(email: email, password: password, confirmPassword: confirmPassword)
                
                if let _ = KeychainHelper.standard.read(service: "user-auth", account: email) {
                    isAlertActive = true
                    alertMessage = "Your email already exist! Please Log In with your registered email"
                } else {
                    if password == confirmPassword {
                        KeychainHelper.standard.save(Data(password.utf8), service: "user-auth", account: email)
                        isNavigate = true
                        currentEmail = email
                    } else {
                        isAlertActive = true
                        alertMessage = "Password doesn't match!"
                    }
                }
            } catch {
                isAlertActive = true
                alertMessage = (error as! LoginValidatorImpl.LoginValidatoreError).localizedDescription
            }
        } else {
            do {
                try validator.validateLogIn(email: email, password: password)
                
                if let data = KeychainHelper.standard.read(service: "user-auth", account: email) {
                    let keyChainPass = String(data: data, encoding: .utf8)
                    
                    if password == keyChainPass {
                        isNavigate = true
                        currentEmail = email
                    } else {
                        isAlertActive = true
                        alertMessage = "Wrong Password!"
                    }
                } else {
                    isAlertActive = true
                    alertMessage = "Your email is not registered! Please register your email first"
                }
            } catch {
                isAlertActive = true
                alertMessage = (error as! LoginValidatorImpl.LoginValidatoreError).localizedDescription
            }
        }
    }
    
}
