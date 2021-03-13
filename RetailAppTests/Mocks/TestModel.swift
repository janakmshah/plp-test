import Foundation

struct TestModel: Decodable, Equatable {
  let value: Int
  static var data = Data("{\"value\": 1}".utf8)
  static var model = TestModel(value: 1)
}
