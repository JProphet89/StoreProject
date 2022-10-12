//
//  Product.swift
//  ProductList
//
//  Created by João Fonseca on 11/10/2022.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
    let description: String
    let price: Float
    let discountPercentage: Float
    let rating: Float
    let stock: Int
    let brand: String
    let category: String
    let thumbnail: String
    let images: [String]
}
