//
//  ProductService.swift
//  ProductList
//
//  Created by João Fonseca on 11/10/2022.
//

import Combine
import Foundation

protocol ProductService {
    func getProducts() -> AnyPublisher<Products, Never>
}

class DefaultProductService: ProductService {
    func getProducts() -> AnyPublisher<Products, Never> {
        guard let url = URL(string: .productURL) else {
            return Just(getProducts()).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Products.self, decoder: JSONDecoder())
            .map({ [weak self] products in
                self?.saveProducts(products: products)
                return products
            })
            .replaceError(with: getProducts())
            .eraseToAnyPublisher()
    }

    //MARK: - Save products to disk to work offline
    private let productsKey = "productsList"
    private func saveProducts(products: Products) {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        guard let listEncoded = try? encoder.encode(products) else {
            return
        }
        userDefaults.set(listEncoded, forKey: productsKey)
    }

    private func getProducts() -> Products {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        guard
            let savedProductList = userDefaults.object(forKey: productsKey) as? Data,
            let listDecoded = try? decoder.decode(Products.self, from: savedProductList)
        else {
            return .empty
        }
        return listDecoded
    }
}

private extension String {
    static let productURL = "https://dummyjson.com/products?limit=100"
}
