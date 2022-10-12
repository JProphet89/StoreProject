//
//  Products.swift
//  ProductList
//
//  Created by João Fonseca on 11/10/2022.
//

import Foundation

struct Products: Codable {
    let products: [Product]
    let total: Int
    let skip: Int
    let limit: Int
}

extension Products{
    static let empty = Products(products: [], total: 0, skip: 0, limit: 0)
}
