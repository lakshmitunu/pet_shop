//
//  AsyncImageView.swift
//  Pet Shop
//
//  Created by Lakshmi on 20/04/24.
//

import SwiftUI

struct AsyncImageView: View {
    let url: String
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if phase.error != nil {
                Image(systemName: "photo")
                    .font(.system(size: 50))
                    .foregroundColor(Color.gray.opacity(0.5))
            } else {
                ProgressView()
            }
        }
    }
}
