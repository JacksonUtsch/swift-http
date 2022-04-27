import XCTest
@testable import HTTP

final class AsyncTest: XCTestCase {
	@available(macOS 12.0, *)
	func testMakeRequest() async {
		do {
			let result = try await HTTP.async(
				at: "http://api.plos.org/",
				with: HTTP.AnyEndpoint<[String: String]>(method: .get, route: "search?q=title:DNA"),
				catching: { (_) -> Optional<Never> in nil }
			)
			print("Got result: \(result.keys)")
		} catch {
			XCTFail("Found Error: \(error)")
		}
	}
}
