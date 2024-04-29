//
//  AppDelegate.swift
//  Pet Shop
//
//  Created by Lakshmi on 24/04/24.
//

import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        #if DEBUG
        print("Is UI Test Running: \(UITestingHelper.isUITesting)")
        #endif
        return true
    }
}
