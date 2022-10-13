//
//  ContentViewDataTest.swift
//  ProductListTests
//
//  Created by João Fonseca on 13/10/2022.
//

import Combine
@testable import ProductList
import XCTest

final class ContentViewDataTest: XCTestCase {
    private(set) var mockProductService: ProductService!
    private(set) var bagService: BagService!
    private var subscriptions: Set<AnyCancellable> = .init()
    var sut: ContentViewData!

    override func setUp() {
        super.setUp()
        mockProductService = MockProductService()
        bagService = DefaultBagService()
        sut = .init(productService: mockProductService, bagService: bagService)
    }

    override func tearDown() {
        subscriptions.forEach({ $0.cancel() })
    }

    func testAddProductToBag() {
        sut.addProduct(.empty)
        let bagExpectation = expectation(description: "should received 1 item on the bag")
        sut.bagService.getList()
            .first()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                bagExpectation.fulfill()
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)
        XCTAssertEqual(sut.products.products.count, 30)
        XCTAssertEqual(sut.bagList.count, 1)
        XCTAssertEqual(sut.bagList.first?.quantity, 1)
    }
}
