import XCTest

@testable import HTTP

final class AsyncTest: XCTestCase {
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func testMakeRequest() async {
    do {
      let result = try await HTTP.async(
        at: "http://api.plos.org/",
        with: HTTP.AnyEndpoint<Data>(method: .get, route: "search?q=title:DNA"),
        catching: { (_) -> Never? in nil },
        dumping: true
      )
      print("Got result: \(result)")
    } catch {
      XCTFail("Found Error: \(error)")
    }
  }

  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func testMakeRequestResult() async {
    let result = await HTTP.asyncResult(
      at: "http://api.plos.org/",
      with: HTTP.AnyEndpoint<Data>(method: .get, route: "search?q=title:DNA"),
      catching: { (_) -> Never? in nil },
      dumping: true
    )

    switch result {
    case .success(let result):
      print("Got result: \(result)")
    case .failure(let error):
      XCTFail("Found Error: \(error)")
    }
  }
}
