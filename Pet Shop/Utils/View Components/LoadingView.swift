//
//  LoadingView.swift
//  Pet Shop
//
//  Created by Lakshmi on 17/04/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5, anchor: .center)
        }
        .frame(width: 110, height: 110)
        .background(Color.black.opacity(0.6))
        .cornerRadius(16)
    }
}
//
//#Preview {
//    LoadingView()
//}
