//
//  ContentView.swift
//  ProductList
//
//  Created by João Fonseca on 11/10/2022.
//

import CoreData
import SwiftUI

struct ParentFunctionKey: EnvironmentKey {
    static let defaultValue: ((Product) -> Void)? = nil
}

extension EnvironmentValues {
    var addProduct: ((Product) -> Void)? {
        get { self[ParentFunctionKey.self] }
        set { self[ParentFunctionKey.self] = newValue }
    }
}

struct ContentView: View {
    @EnvironmentObject var dataController: ContentViewData

    var body: some View {
        if !hasProducts {
            loadingView
        } else {
            ScrollView {
                Text("\($dataController.bagList.count)")
                ForEach(dataController.products.products, id: \.id) { product in
                    ProductListView(product: product)
                        .environment(\.addProduct, addProduct(product: ))
                        .padding(.init(top: 5, leading: 10, bottom: 5, trailing: 10))
                        .fullExpand()
                        
                }
            }
        }
    }

    var hasProducts: Bool {
        !dataController.products.products.isEmpty
    }

    private var loadingView: some View {
        VStack(alignment: .center) {
            Spacer()
            LottieView(lottieFile: "loading")
                .frame(width: 300, height: 300)
            Spacer()
        }
    }
    
    func addProduct(product:Product){
        dataController.addProduct(product)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(
                ContentViewData(productService: DefaultProductService(),bagService: DefaultBagService())
            )
    }
}
