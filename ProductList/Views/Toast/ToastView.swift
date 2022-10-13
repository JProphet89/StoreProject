//
//  ToastView.swift
//  ProductList
//
//  Created by João Fonseca on 13/10/2022.
//

import SwiftUI

struct ToastView: View {
    var title: String
    var message: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.caption)
                    
                    Text(message)
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
        }
        .accessibilityLabel("accessibilityToastView")
        .background(.white)
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
        
    }
}
