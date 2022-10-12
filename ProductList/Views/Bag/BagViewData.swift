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
    let bagService: BagService
    private var subscriptions: Set<AnyCancellable> = .init()

    init(bagService: BagService) {
        bagList = []
        self.bagService = bagService
        bagService.getList()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                self?.bagList = items
            }.store(in: &subscriptions)
    }
    
    func removeAll(){
        bagService.removeAll()
    }
}

