//
//  LoginFormValidator.swift
//  Pet Shop
//
//  Created by Lakshmi on 25/04/24.
//

import Foundation

protocol LoginValidator {
    func validateLogIn(email: String, password: String) throws
    func validateSignUp(email: String, password: String, confirmPassword: String) throws
}

struct LoginValidatorImpl: LoginValidator {
    func validateLogIn(email: String, password: String) throws {
        if email.isEmpty {
            throw LoginValidatoreError.invalidEmailEmpty
        }
        
        if password.isEmpty {
            throw LoginValidatoreError.invalidPasswordEmpty
        }
        
        if !email.isValidEmail {
            throw LoginValidatoreError.invalidEmail
        }
    }
    
    func validateSignUp(email: String, password: String, confirmPassword: String) throws {
        if email.isEmpty {
            throw LoginValidatoreError.invalidEmailEmpty
        }
        
        if password.isEmpty {
            throw LoginValidatoreError.invalidPasswordEmpty
        }
        
        if confirmPassword.isEmpty {
            throw LoginValidatoreError.invalidConfirmPasswordEmpty
        }
        
        if !email.isValidEmail {
            throw LoginValidatoreError.invalidEmail
        }
    }
}

extension LoginValidatorImpl {
    enum LoginValidatoreError: LocalizedError {
        case invalidEmailEmpty
        case invalidPasswordEmpty
        case invalidConfirmPasswordEmpty
        case invalidEmail
        
        var errorDescription: String? {
            switch self {
            case .invalidEmailEmpty:
                return "Email can't be empty"
            case .invalidPasswordEmpty:
              return "Password can't be empty"
            case .invalidConfirmPasswordEmpty:
              return "Confirm Password can't be empty"
            case .invalidEmail:
              return "Invalid Email! Enter Correct Email"
            }
        }
    }
}
