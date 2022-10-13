//
//  BagServiceTest.swift
//  ProductListTests
//
//  Created by João Fonseca on 13/10/2022.
//

import Combine
@testable import ProductList
import XCTest

final class BagServiceTest: XCTestCase {
    private(set) var mockProductService: ProductService!
    private var subscriptions: Set<AnyCancellable> = .init()

    private let sut: BagService = DefaultBagService()

    override func setUp() {
        super.setUp()
        mockProductService = MockProductService()
    }

    override func tearDown() {
        subscriptions.forEach({ $0.cancel() })
    }

    func testAddProductToBag() throws {
        // Add Fetch Products
        let productsList: Products = getProducts()
        guard
            let firstProduct = productsList.products.first,
            let secondProduct = productsList.products.last
        else {
            XCTAssertTrue(false, "should be able to fetch the first product")
            return
        }
        sut.removeAll()
        // Add one product to the bag
        sut.add(product: firstProduct)
        var bagExpectation = expectation(description: "should have one item on the bag")
        var quatityForFirst = 1
        var numberOfItems = 1
        sut.getList().sink { bagItems in
            XCTAssertEqual(bagItems.count, numberOfItems)
            XCTAssertTrue(bagItems.contains(where: { $0.product.id == firstProduct.id }))
            XCTAssertEqual(bagItems.first?.quantity, quatityForFirst)
            bagExpectation.fulfill()
        }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)

        // Add second product to the bag, bag should only have 1 product but 2 in quantity
        bagExpectation = expectation(description: "should increase the quantity of the product in the bag")
        quatityForFirst = 2
        sut.add(product: firstProduct)

        waitForExpectations(timeout: 2)

        // Add second item to the bag, bag should only have 2 items 1 product with 2 in quantity and the other one with the only one
        bagExpectation = expectation(description: "should add second item on the bag")
        numberOfItems = 2
        sut.add(product: secondProduct)

        waitForExpectations(timeout: 2)
    }

    func testReduceProductToBag() throws {
        // Add Fetch Products
        let productsList: Products = getProducts()
        guard let product = productsList.products.first else {
            XCTAssertTrue(false, "should be able to fetch the first product")
            return
        }
        sut.removeAll()
        // Add two product to the bag
        sut.add(product: product)
        sut.add(product: product)
        var bagExpectation = expectation(description: "should have two items on the bag")
        var quatity = 2
        sut.getList().sink { bagItems in
            XCTAssertEqual(bagItems.count, 1)
            XCTAssertTrue(bagItems.contains(where: { $0.product.id == product.id }))
            XCTAssertEqual(bagItems.first?.quantity, quatity)
            bagExpectation.fulfill()
        }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)

        // Recude the number of products in the bag
        bagExpectation = expectation(description: "should reduce to 1 quantity the item on the bag")
        quatity = 1
        sut.reduce(product: product)

        waitForExpectations(timeout: 2)
    }

    func testRemoveAllProductToBag() throws {
        // Add Fetch Products
        let productsList: Products = getProducts()
        guard let product = productsList.products.first else {
            XCTAssertTrue(false, "should be able to fetch the first product")
            return
        }
        sut.removeAll()
        // Add two product to the bag
        sut.add(product: product)
        sut.add(product: product)
        var bagExpectation = expectation(description: "should have two items on the bag")
        sut.getList().first().sink { bagItems in
            XCTAssertEqual(bagItems.count, 1)
            XCTAssertTrue(bagItems.contains(where: { $0.product.id == product.id }))
            XCTAssertEqual(bagItems.first?.quantity, 2)
            bagExpectation.fulfill()
        }.store(in: &subscriptions)
        waitForExpectations(timeout: 2)

        // Remove all items from the bag
        bagExpectation = expectation(description: "should reduce to 1 quantity the item on the bag")
        sut.removeAll()
        sut.getList().first().sink { bagItems in
            XCTAssertEqual(bagItems.count, 0)
            bagExpectation.fulfill()
        }.store(in: &subscriptions)

        waitForExpectations(timeout: 2)
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
