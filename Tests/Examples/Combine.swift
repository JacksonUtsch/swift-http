import Combine
import XCTest
@testable import HTTP

final class CombineTest: XCTestCase {
	var cancellables: Set<AnyCancellable> = []
	
    func testMakeRequest() throws {
		let semaphore = DispatchSemaphore(value: 0)
		HTTP.publisher(
			at: "http://api.plos.org/",
			with: HTTP.AnyEndpoint<[String: String]>(method: .get, route: "search?q=title:DNA"),
			including: ["Content-Type": "application/json"],
			catching: { (_) -> Optional<Never> in nil },
			dumping: true
		).sink(receiveCompletion: { completion in
			switch completion {
			case .finished:
				print("finished")
				semaphore.signal()
			case .failure(let error):
				XCTFail("Failure: \(error)")
				semaphore.signal()
			}
		}, receiveValue: { result in
			print(result)
			semaphore.signal()
		}).store(in: &cancellables)
		semaphore.wait()
	}
}
