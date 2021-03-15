import Foundation
@testable import RetailApp

class MockProductsService: ProductsService {
    private(set) var lastCompletion: ((Result<Products, Error>) -> Void)?
    var callCount = 0
    func getProducts(completion: @escaping (Result<Products, Error>) -> Void) {
        lastCompletion = completion
        callCount += 1
    }
}
