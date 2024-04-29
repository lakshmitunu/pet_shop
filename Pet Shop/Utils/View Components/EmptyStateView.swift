//
//  EmptyStateView.swift
//  Pet Shop
//
//  Created by Lakshmi on 20/04/24.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "arrow.clockwise")
                .font(.title)
                .padding(.bottom, 5)
            Text("No Data! \nRefresh by pulling down")
                .multilineTextAlignment(.center)
        }
        .foregroundColor(.gray)
    }
}

//#Preview {
//    EmptyStateView()
//}
