//
//  BagViewData.swift
//  ProductList
//
//  Created by João Fonseca on 12/10/2022.
//

import Combine
import Foundation

class BagViewData: ObservableObject {
    @Published var bagList: [BagItem]
    @Published var totalPrice: Float = 0

    let bagService: BagService
    private var subscriptions: Set<AnyCancellable> = .init()

    init(bagService: BagService) {
        bagList = []
        self.bagService = bagService
        bagService.getList()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.bagList = items
                self?.calculateTotal()
            }.store(in: &subscriptions)
    }

    func removeAll() {
        bagService.removeAll()
    }
    
    func bagAddQuatity(product:Product){
        bagService.add(product: product)
    }
    
    func bagReduceQuatity(product:Product){
        bagService.reduce(product: product)
    }
    
    func bagRemove(product:Product){
        bagService.remove(product: product)
    }

    private func calculateTotal() {
        var total: Float = 0.0
        bagList.forEach({
            total += Float($0.quantity) * $0.product.price
        })
        totalPrice = total
    }
}


struct BagOperation{
    let product: Product
    let operation: Operation
    
    enum Operation {
        case add
        case reduce
        case remove
    }
}
