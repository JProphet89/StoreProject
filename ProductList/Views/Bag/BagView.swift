//
//  BagView.swift
//  ProductList
//
//  Created by João Fonseca on 12/10/2022.
//

import SwiftUI

struct BagView: View {
    @EnvironmentObject var dataController: BagViewData
    @Environment(\.dismiss) private var dismiss
    @State private var removeAll: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                Text("Hello, World!")
            }
            .navigationBarTitle("Your Cart")
            .toolbar(content: {
                Button {
                    removeAll = true
                } label: {
                    Image(systemName: "cart.badge.minus")
                        .foregroundColor(.black)
                }
            })
            .alert(isPresented: $removeAll) {
                Alert(title: Text("Do you want to clean your cart?"),
                      primaryButton:
                      .default(Text("Yes please"), action: {
                          dataController.removeAll()
                          dismiss()
                      }),
                      secondaryButton:
                      .destructive(Text("Never mind")))
            }
        }
    }
}

struct BagView_Previews: PreviewProvider {
    static var previews: some View {
        BagView()
    }
}
