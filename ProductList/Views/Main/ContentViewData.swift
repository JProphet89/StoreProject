//
//  ContentViewData.swift
//  ProductList
//
//  Created by João Fonseca on 11/10/2022.
//

import Combine
import Foundation

class ContentViewData: ObservableObject {
    @Published var products: Products = .empty
    @Published var bagList: [BagItem] = []
    let productService: ProductService
    let bagService: BagService
    private var subscriptions: Set<AnyCancellable> = .init()

    init(productService: ProductService, bagService: BagService) {
        self.productService = productService
        self.bagService = bagService
        fetchProducts()
        self.bagService.getList()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.bagList = items
            }.store(in: &subscriptions)
    }

    func addProduct(_ product: Product) {
        bagService.add(product: product)
    }

    private func fetchProducts() {
        productService.getProducts()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.products = products
            }
            .store(in: &subscriptions)
    }
}
