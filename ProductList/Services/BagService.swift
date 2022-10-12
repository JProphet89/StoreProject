//
//  BagService.swift
//  ProductList
//
//  Created by João Fonseca on 12/10/2022.
//

import Foundation
import Combine

protocol BagService {
    func getList() -> AnyPublisher<[BagItem],Never>
    func add(product: Product)
    func remove(product: Product)
    func removeAll()
}

class DefaultBagService: BagService {
    private let bagKey = "storeBag"
    @Published private var bagList: [BagItem] = []

    init() {
        bagList = getBagInMemory()
    }

    func getList() -> AnyPublisher<[BagItem],Never> {
        $bagList.eraseToAnyPublisher()
    }

    func add(product: Product) {
        if bagList.contains(where: { $0.product.id == product.id }) {
            bagList = bagList.map({ item in
                guard
                    item.product.id == product.id,
                    item.quantity + 1 < item.product.stock
                else {
                    return item
                }
                var mutableItem = item
                mutableItem.quantity += 1
                return mutableItem
            })
        } else {
            bagList.append(.init(product: product))
        }
        setBagInMemory()
    }

    func remove(product: Product) {
        bagList.removeAll(where: { $0.product.id == product.id })
        setBagInMemory()
    }
    
    func removeAll(){
        bagList = []
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

    private func getBagInMemory() -> [BagItem] {
        let userDefaults = UserDefaults.standard
        let decoder = JSONDecoder()
        guard
            let savedBagList = userDefaults.object(forKey: bagKey) as? Data,
            let listDecoded = try? decoder.decode([BagItem].self, from: savedBagList)
        else {
            return []
        }
        return listDecoded
    }
}
