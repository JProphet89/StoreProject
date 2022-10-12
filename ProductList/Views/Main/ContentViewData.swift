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
    @Published var bagList: [Product]
    let productService: ProductService
    let bagService: BagService
    private var subscriptions: Set<AnyCancellable> = .init()

    init(productService: ProductService, bagService: BagService) {
        self.productService = productService
        self.bagService = bagService
        bagList = self.bagService.getList()
        fetchProducts()
    }
    
    func addProduct(_ product:Product){
        bagList.append(product)
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
