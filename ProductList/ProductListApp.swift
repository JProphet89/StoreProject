//
//  ProductListApp.swift
//  ProductList
//
//  Created by João Fonseca on 11/10/2022.
//

import SwiftUI

@main
struct ProductListApp: App {
#if DEBUG
    let productService: ProductService = ProcessInfo.processInfo.arguments.contains("UITest") ? MockProductService() : DefaultProductService()
#else
    let productService = DefaultProductService()
#endif

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(
                    ContentViewData(
                        productService: productService,
                        bagService: DefaultBagService()
                    )
                )
        }
    }
}
