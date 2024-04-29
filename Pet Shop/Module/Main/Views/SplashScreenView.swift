//
//  SplashScreenView.swift
//  Pet Shop
//
//  Created by Lakshmi on 16/04/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isFinished = false
    @State private var logoSize = 0.6
    @State private var logoOpacity = 0.3
    
    var body: some View {
        if isFinished {
            LoginView()
        } else {
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Image("dog")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 230)
                            .padding(.leading, -20)
                            .padding(.top, 30)
                        Spacer()
                    }
                }
                
                VStack {
                    Image("PawShopLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 260)
                        .foregroundColor(Color.appPrimaryColor)
                }
                .scaleEffect(logoSize)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.4)) {
                        logoSize = 1
                        logoOpacity = 1
                    }
                }
            }
            .ignoresSafeArea()
            .background(Color.mainBgColor)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    withAnimation {
                        isFinished = true
                    }
                })
            }
        }
    }
}

//#Preview {
//    SplashScreenView()
//}
