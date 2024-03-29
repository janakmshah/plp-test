import UIKit

enum ImageDecodingError: Error {
    case badData
}

protocol ImageService {
    func downloadImage(key: String, completion: @escaping (Result<UIImage, Error>) -> Void)
}

class ImageServiceImplementation: ImageService {
    private let api: API
    
    init(api: API) {
        self.api = api
    }
    
    func downloadImage(key: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        
        // First check cache
        if let cachedImage = ImageCache.fetch(for: key) {
            return completion(.value(cachedImage))
        }
        
        let resource = Resource(path: "image/\(key).jpg", body: nil, method: "GET") { data -> Result<UIImage, Error> in
            guard let image = UIImage(data: data) else {
                return .error(ImageDecodingError.badData)
            }
            ImageCache.cache(image, for: key) // Save to cache
            return .value(image)
        }
        api.load(resource, completion: completion)
    }
    
}
