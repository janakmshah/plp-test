import XCTest
@testable import RetailApp

class ProductListingsViewModelTests: XCTestCase {
    
    let products = Products(products: [ProductDetailsBasic(id: "", name: "title", imageKey: "imageKey", price: Price(currentPrice: 100, originalPrice: nil, currencyCode: "GBP"), offerIds: ["1", "2"])])
    
    let displayProducts = [ProductCellDisplayableImplementation(title: "title",
                                                                imageKey: "imageKey",
                                                                price: NSAttributedString(string: "price"),
                                                                offerIds: ["1", "2"])]
    
    let productDetails = ProductDetails(id: "1", name: "name", imageKey: "imageKey", price: Price(currentPrice: 1000, originalPrice: nil, currencyCode: "GBP"), information: [ProductInformation(sectionTitle: "title", sectionText: "section")])
    
    func test_init_startsFetchingProducts() {
        let mockProductsService = MockProductsService()
        _ = ProductListingsViewModel(coordinator: AppCoordinator(), productsService: mockProductsService)
        XCTAssertEqual(mockProductsService.callCount, 1)
    }
    
    func test_productsArrayIsUpdated_whenProductsAreSuccessfullyFetched() {
        let mockProductsService = MockProductsService()
        
        let productsListingsViewModel = ProductListingsViewModel(coordinator: AppCoordinator(), productsService: mockProductsService)
        
        let actionExpectation = expectation(description: "updated")
        productsListingsViewModel.displayProducts.bindNoFire(self) { products in
            XCTAssertEqual(products.map { $0.title }, self.displayProducts.map { $0.title })
            actionExpectation.fulfill()
        }
        
        mockProductsService.lastCompletion?(.value(products))
        wait(for: [actionExpectation], timeout: 0.5)
    }
        
}
