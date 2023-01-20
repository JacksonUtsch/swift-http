import Combine
import XCTest

@testable import HTTP

final class CombineTest: XCTestCase {
  var cancellables: Set<AnyCancellable> = []

  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  func testMakeRequest() throws {
    let semaphore = DispatchSemaphore(value: 0)
    HTTP.publisher(
      at: "http://api.plos.org/",
      with: HTTP.AnyEndpoint<Data>(method: .get, route: "search?q=title:DNA"),
      including: ["Content-Type": "application/json"],
      catching: { (_) -> Never? in nil },
      dumping: true
    ).sink(
      receiveCompletion: { completion in
        switch completion {
        case .finished:
          print("finished")
          semaphore.signal()
        case .failure(let error):
          XCTFail("Failure: \(error)")
          semaphore.signal()
        }
      },
      receiveValue: { result in
        print(result)
        semaphore.signal()
      }
    ).store(in: &cancellables)
    semaphore.wait()
  }
}
