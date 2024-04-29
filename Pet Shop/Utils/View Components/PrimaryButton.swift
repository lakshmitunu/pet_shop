//
//  PrimaryButton.swift
//  Pet Shop
//
//  Created by Lakshmi on 16/04/24.
//

import SwiftUI

struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 54, alignment: .center)
            .font(.system(size: 17, weight: .bold))
            .background(Color.accentColor)
            .foregroundColor(.white)
            .cornerRadius(16)
    }
}
