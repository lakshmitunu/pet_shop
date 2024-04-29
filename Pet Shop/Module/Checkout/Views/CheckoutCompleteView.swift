//
//  CheckoutCompleteView.swift
//  Pet Shop
//
//  Created by Lakshmi on 20/04/24.
//

import SwiftUI

struct CheckoutCompleteView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 120))
                .foregroundColor(Color.appPrimaryColor)
            
            Text("Congratulations")
                .font(.custom("LeckerliOne-Regular", size: 32))
                .bold()
            
            Text("Your order has been successfully placed.")
                .multilineTextAlignment(.center)
            
            let orderId = String(Int.random(in: 100000...999999))
            Text("Order ID is **\(orderId)**")
        }
    }
}
//
//#Preview {
//    CheckoutCompleteView()
//}
