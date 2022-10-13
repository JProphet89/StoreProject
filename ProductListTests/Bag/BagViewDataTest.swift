//
//  BagViewDataTest.swift
//  ProductListTests
//
//  Created by João Fonseca on 13/10/2022.
//

import Combine
@testable import ProductList
import XCTest

final class BagViewDataTest: XCTestCase {
    private(set) var mockProductService: ProductService!
    private(set) var bagService: BagService!
    private var subscriptions: Set<AnyCancellable> = .init()
    var sut: BagViewData!

    override func setUp() {
        super.setUp()
        mockProductService = MockProductService()
        bagService = DefaultBagService()
        bagService.removeAll()
        sut = .init(bagService: bagService)
    }

    override func tearDown() {
        subscriptions.forEach({ $0.cancel() })
    }

    func testIncreaseQuantityProductToBagAndTotal() {
        guard let product = getProducts().products.first else {
            XCTAssertTrue(false)
            return
        }
        var bagExpectation = expectation(description: "should received 1 item on the bag")
        sut.bagAddQuatity(product: product)
        sut.bagService.getList()
            .first()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                bagExpectation.fulfill()
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)
        XCTAssertEqual(sut.bagList.count, 1)
        XCTAssertEqual(sut.bagList.first?.quantity, 1)

        bagExpectation = expectation(description: "should received 2 item on the bag")
        sut.bagAddQuatity(product: product)
        sut.bagService.getList()
            .first()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                bagExpectation.fulfill()
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)
        XCTAssertEqual(sut.bagList.count, 1)
        XCTAssertEqual(sut.bagList.first?.quantity, 2)
        XCTAssertEqual(sut.totalPrice, (sut.bagList.first?.product.price ?? 0) * 2.0)
    }

    func testReduceQuantityProductToBagAndTotal() {
        guard let product = getProducts().products.first else {
            XCTAssertTrue(false)
            return
        }
        var bagExpectation = expectation(description: "should received 2 product on the bag from 1 item")
        sut.bagAddQuatity(product: product)
        sut.bagAddQuatity(product: product)
        sut.bagService.getList()
            .first()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                bagExpectation.fulfill()
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)
        XCTAssertEqual(sut.bagList.count, 1)
        XCTAssertEqual(sut.bagList.first?.quantity, 2)
        XCTAssertEqual(sut.totalPrice, (sut.bagList.first?.product.price ?? 0) * 2.0)

        bagExpectation = expectation(description: "should received 1 product on the bag from 1 item")
        sut.bagReduceQuatity(product: product)
        sut.bagService.getList()
            .first()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                bagExpectation.fulfill()
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)
        XCTAssertEqual(sut.bagList.count, 1)
        XCTAssertEqual(sut.bagList.first?.quantity, 1)
        XCTAssertEqual(sut.totalPrice, (sut.bagList.first?.product.price ?? 0) * 1.0)
    }

    func testRemoveAllProductsfromBagAndTotal() {
        guard let product = getProducts().products.first else {
            XCTAssertTrue(false)
            return
        }
        var bagExpectation = expectation(description: "should received 2 product on the bag from 1 item")
        sut.bagAddQuatity(product: product)
        sut.bagAddQuatity(product: product)
        sut.bagService.getList()
            .first()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                bagExpectation.fulfill()
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)
        XCTAssertEqual(sut.bagList.count, 1)
        XCTAssertEqual(sut.bagList.first?.quantity, 2)
        XCTAssertEqual(sut.totalPrice, (sut.bagList.first?.product.price ?? 0) * 2.0)

        bagExpectation = expectation(description: "should received 1 product on the bag from 1 item")
        sut.removeAll()
        sut.bagService.getList()
            .first()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                bagExpectation.fulfill()
            }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)
        XCTAssertEqual(sut.bagList.count, 0)
        XCTAssertEqual(sut.totalPrice, 0)
    }

    private func getProducts() -> Products {
        let productExpectation = expectation(description: "there will be products")
        var productsList: Products = .empty
        mockProductService.getProducts().sink { products in
            productsList = products
            productExpectation.fulfill()
        }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)
        return productsList
    }
}
