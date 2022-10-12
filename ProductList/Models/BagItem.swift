//
//  BagItem.swift
//  ProductList
//
//  Created by João Fonseca on 12/10/2022.
//

import Foundation

struct BagItem: Codable {
    var quantity: Int = 1
    let product: Product
}
