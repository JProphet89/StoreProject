//
//  MockProductService.swift
//  ProductListTests
//
//  Created by João Fonseca on 13/10/2022.
//

import Combine
import Foundation
@testable import ProductList

class MockProductService: ProductService {
    func getProducts() -> AnyPublisher<Products, Never> {
        if let url = Bundle.main.url(forResource: "Products", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(Products.self, from: data)
                return Just(jsonData).eraseToAnyPublisher()
            } catch {
                return Just(.empty).eraseToAnyPublisher()
            }
        }
        return Just(.empty).eraseToAnyPublisher()
    }
}
