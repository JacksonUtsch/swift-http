import Combine
import XCTest

@testable import HTTP

final class ErrorsTests: XCTestCase {
  func testInvalidURL() throws {
    XCTAssertEqual(
      "\(HTTP.Errors<Never>.invalidURL)",
      "invalidURL"
    )

    XCTAssertEqual(
      HTTP.Errors<Never>.invalidURL.description,
      "invalidURL"
    )

    XCTAssertEqual(
      HTTP.Errors<Never>.invalidURL.localizedDescription,
      "Invalid URL"
    )

    XCTAssertEqual(
      HTTP.Errors<Never>.invalidURL.errorDescription,
      "Invalid URL"
    )
  }

  func testEncodingError() {
    let encodingError = EncodingError.invalidValue(
      Int.self, .init(codingPath: [], debugDescription: ""))
    let error = HTTP.Errors<Never>.encoding(encodingError)

    XCTAssertEqual(
      error.description,
      """
      			encoding(invalidValue(Swift.Int, Swift.EncodingError.Context(codingPath: [], debugDescription: "", underlyingError: nil)))
      			"""
    )

    XCTAssertEqual(
      error.localizedDescription,
      "The data couldn’t be written because it isn’t in the correct format."
    )
  }

  func testDecodingError() {
    let testData = """
      {"abc":}
      """.data(using: .utf8)!
    do {
      _ = try JSONDecoder().decode(String.self, from: testData)
    } catch {
      if let error = error as? DecodingError {
        _ = HTTP.Errors<Never>.decoding(error)
      } else {
        XCTFail("Failed to cast decoding error")
      }
    }

    let error = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: ""))

    XCTAssertEqual(
      "\(error)",
      """
      			dataCorrupted(Swift.DecodingError.Context(codingPath: [], debugDescription: "", underlyingError: nil))
      			"""
    )

    XCTAssertEqual(
      error.localizedDescription,
      "The data couldn’t be read because it isn’t in the correct format."
    )
  }

  func testURLError() {
    let urlError = URLError(URLError.badURL)
    let error = HTTP.Errors<Never>.url(urlError)

    XCTAssertEqual(
      error.description,
      """
      			url(URLError(_nsError: Error Domain=NSURLErrorDomain Code=-1000 "(null)"))
      			"""
    )

    XCTAssertEqual(
      error.localizedDescription,
      """
      				 The operation couldn’t be completed. (NSURLErrorDomain error -1000.)
      				 """
    )
  }

  func testCaughtErrors() {
    struct ServerError: LocalizedError, Codable, CustomStringConvertible {
      var status: Int
      var message: String

      var description: String {
        "ServerError(status: \(status), message: \(message))"
      }

      var errorDescription: String? {
        "ServerError(status: \(status), message: \(message))"
      }
    }
    let caughtError = ServerError(status: 404, message: "Not Found")
    let error = HTTP.Errors<ServerError>.caught(caughtError)

    XCTAssertEqual(
      error.description,
      """
      			caught(ServerError(status: 404, message: Not Found))
      			"""
    )

    XCTAssertEqual(
      error.localizedDescription,
      """
      			ServerError(status: 404, message: Not Found)
      			"""
    )
  }

  func testUncaughtError() {
    struct ServerError: LocalizedError, Codable, CustomStringConvertible {
      var status: Int
      var message: String

      var description: String {
        "ServerError(status: \(status), message: \(message))"
      }

      var errorDescription: String? {
        "ServerError(status: \(status), message: \(message))"
      }
    }
    let caughtError = ServerError(status: 404, message: "Not Found")
    let error = HTTP.Errors<ServerError>.uncaught(caughtError)

    XCTAssertEqual(
      error.description,
      """
      			uncaught(ServerError(status: 404, message: Not Found))
      			"""
    )

    XCTAssertEqual(
      error.localizedDescription,
      """
      			ServerError(status: 404, message: Not Found)
      			"""
    )
  }
}
