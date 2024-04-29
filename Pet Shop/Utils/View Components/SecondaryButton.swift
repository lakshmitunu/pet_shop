//
//  SecondaryButton.swift
//  Pet Shop
//
//  Created by Lakshmi on 20/04/24.
//

import SwiftUI

struct SecondaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 54, alignment: .center)
            .font(.system(size: 17, weight: .bold))
            .background(Color.clear)
            .foregroundColor(Color.appPrimaryColor)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.appPrimaryColor, lineWidth: 1)
            )
    }
}
