import Combine
import XCTest

@testable import HTTP

final class AnyEncodableTests: XCTestCase {
  func testDictionaryCast() {
    let anyEncodable = HTTP.AnyEncodable(["letter": "a", "message": "plain text"])
    XCTAssertEqual(
      anyEncodable.encodable as? [String: String], .some(["letter": "a", "message": "plain text"]))
  }

  func testCustomCast() {
    struct ACodable: Codable, Equatable {
      var prop: String
    }

    let aCodable = ACodable(prop: "the property!")
    let anyEncodable = HTTP.AnyEncodable(aCodable)

    XCTAssertEqual(anyEncodable.encodable as? ACodable, aCodable)
  }
}
