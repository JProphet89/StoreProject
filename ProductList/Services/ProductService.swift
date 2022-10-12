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
            return Just(.empty).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Products.self, decoder: JSONDecoder())
            .replaceError(with: .empty)
            .eraseToAnyPublisher()
    }
}

private extension String {
    static let productURL = "https://dummyjson.com/products?limit=100"
}
