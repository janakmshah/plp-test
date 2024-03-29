import UIKit
@testable import RetailApp

class MockImageService: ImageService {
  var onDownloadCalled: (() -> Void)?
  private(set) var lastCompletion: ((Result<UIImage, Error>) -> Void)?
  var callCount = 0
  var requestedKeys: [String] = []

  func downloadImage(key: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
    lastCompletion = completion
    callCount += 1
    requestedKeys.append(key)
    onDownloadCalled?()
  }
}
