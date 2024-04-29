//
//  Pet_ShopApp.swift
//  Pet Shop
//
//  Created by Lakshmi on 16/04/24.
//

import SwiftUI

@main
struct Pet_ShopApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SplashScreenView()
                    .onAppear {
                        let largeTitle = UIFont.preferredFont(forTextStyle: .largeTitle)
                        let regularTitle = UIFont.preferredFont(forTextStyle: .body)

                        let largeFont = UIFont(name: "LeckerliOne-Regular", size: largeTitle.pointSize)
                        let regularFont = UIFont(name: "LeckerliOne-Regular", size: regularTitle.pointSize)
                        
                        UINavigationBar.appearance().largeTitleTextAttributes = [.font : largeFont ?? ""]

                        UINavigationBar.appearance().titleTextAttributes = [.font : regularFont ?? ""]
                    }
                
            }
        }
    }
}
