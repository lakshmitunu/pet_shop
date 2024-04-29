//
//  UITestingHelper.swift
//  Pet Shop
//
//  Created by Lakshmi on 24/04/24.
//

#if DEBUG
import Foundation

struct UITestingHelper {
    
    static var isUITesting: Bool {
        ProcessInfo.processInfo.arguments.contains("-ui-testing")
        
    }
    
    static var isBreedsNetworkingSuccessful: Bool {
        ProcessInfo.processInfo.environment["-breeds-networking-success"] == "1"
    }
    
    static var isPetsNetworkingSuccessful: Bool {
        ProcessInfo.processInfo.environment["-pets-networking-success"] == "1"
    }
    
}

#endif
