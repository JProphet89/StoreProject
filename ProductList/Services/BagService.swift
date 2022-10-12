//
//  BagService.swift
//  ProductList
//
//  Created by João Fonseca on 12/10/2022.
//

import Foundation

protocol BagService {
    func getList() -> [Product]
    func add(product: Product)
    func remove(product: Product)
}

class DefaultBagService: BagService {
    private let bagKey = "storeBag"
    private var bagList: [Product] = []

    init() {
        bagList = getBagInMemory()
    }

    func getList() -> [Product] {
        return bagList
    }

    func add(product: Product) {
        bagList.append(product)
        setBagInMemory()
    }

    func remove(product: Product) {
        bagList.removeAll(where: { $0.id == product.id })
        setBagInMemory()
    }

    private func setBagInMemory() {
        let userDefaults = UserDefaults.standard
        let encoder = JSONEncoder()
        guard let listEncoded = try? encoder.encode(bagList) else {
            return
        }
        userDefaults.set(listEncoded, forKey: bagKey)
    }

    private func getBagInMemory() -> [Product] {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        guard
            let savedBagList = userDefaults.object(forKey: bagKey) as? Data,
            let listDecoded = try? decoder.decode([Product].self, from: savedBagList)
        else {
            return []
        }
        return listDecoded
    }
}
