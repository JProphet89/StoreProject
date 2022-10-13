//
//  BagView.swift
//  ProductList
//
//  Created by João Fonseca on 12/10/2022.
//

import SwiftUI

struct BagFunctionKey: EnvironmentKey {
    static let defaultValue: ((BagOperation) -> Void)? = nil
}

extension EnvironmentValues {
    var bagOperation: ((BagOperation) -> Void)? {
        get { self[BagFunctionKey.self] }
        set { self[BagFunctionKey.self] = newValue }
    }
}

struct BagView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataController: BagViewData

    @State private var removeAll: Bool = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Total: \(dataController.totalPrice, specifier: "%.2f")€")
                    .font(.title)
                    .padding(.init(horizontal: 20))
                ScrollView(.vertical) {
                    ForEach(dataController.bagList, id: \.product.id) { item in
                        BagListItemView(item: item)
                            .environment(\.bagOperation, bagOperation(operation:))
                    }
                }
                .navigationBarTitle("Your Cart")
                .toolbar(content: {
                    removeAllView
                })
                .alert(isPresented: $removeAll) {
                    shouldRemoveAllAlertView
                }
                .accessibilityLabel("accessibilityBagList")
            }
            .fullExpand()
        }
    }

    private var removeAllView: some View {
        Button {
            removeAll = true
        } label: {
            Image(systemName: "cart.badge.minus")
                .foregroundColor(.black)
        }
    }

    private var shouldRemoveAllAlertView: Alert {
        Alert(title: Text("Do you want to clean your cart?"),
              primaryButton:
              .default(Text("Yes please"), action: {
                  dataController.removeAll()
                  dismiss()
              }),
              secondaryButton:
              .destructive(Text("Never mind")))
    }

    // MARK: - functions

    private func bagOperation(operation: BagOperation) {
        switch operation.operation {
        case .add:
            dataController.bagAddQuatity(product: operation.product)
        case .reduce:
            dataController.bagReduceQuatity(product: operation.product)
        case .remove:
            dataController.bagRemove(product: operation.product)
        }
    }
}

struct BagView_Previews: PreviewProvider {
    static var previews: some View {
        BagView()
    }
}
