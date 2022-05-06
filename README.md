# swift-http

![Tests Workflow](https://github.com/JacksonUtsch/swift-http/actions/workflows/tests.yml/badge.svg)
![Format Workflow](https://github.com/JacksonUtsch/swift-http/actions/workflows/format.yml/badge.svg)

Tools to help interface with HTTP calls.

---

## Get Started

To quickly get started create a request using `AnyEndpoint`.

```swift
import HTTP

let getGreeting = HTTP.AnyEndpoint<String>(method: .get, route: "hello")
```

Notice the type specifier for the generic response type. We are expecting to recieve a `String`.

Now let's call this endpoint using either the async or combine function.

### Async
```swift
let result = try await HTTP.async(
  at: "http://127.0.0.1:8080/",
  with: getGreeting,
  catching: { (_) -> Never? in nil }
)
```

### Combine
```swift
let result = try await HTTP.publisher(
  at: "http://127.0.0.1:8080/",
  with: getGreeting,
  catching: { (_) -> Never? in nil }
)
```

## Error Handling
What's this catching thing? Oh yeah, our server can emit errors. Lets define the structure so it can be put into use.

Here we are using [vapor](https://github.com/vapor/vapor) as a local server and can expect the following json error message at the wrong url.

```json
{"error":true,"reason":"Not Found"}
```

Let's define our Swift type.

```swift
struct ServerError: Error, Codable, Hashable {
  let error: Bool
  let reason: String
}
```

Now we can catch the errors given. We'll run this as a test to assert this live implementation.

```swift
do {
  _ = try await HTTP.async(
    at: "http://127.0.0.1:8080/oops/",
    with: getGreeting,
    catching: { data -> ServerError? in
      return try? JSONDecoder().decode(ServerError.self, from: data)
    },
    dumping: true
  )
} catch HTTP.Errors<ServerError>.caught(let serverError) {
  XCTAssertEqual(serverError, ServerError(error: true, reason: "Not Found"))
} catch {
  XCTFail("Expected to catch server error.")
}
```

It's too bad when throwing errors Swift forgets our error type. This is a current advantage of using combine. [Here](https://forums.swift.org/t/precise-error-typing-in-swift/52045) is a thread about adding precise error types to Swift.

## Client Design
swift-http is designed around the protocol `HTTPEndpoint` which is defined as:
```swift
public protocol HTTPEndpoint {
  associatedtype ResponseType: Decodable
  var method: HTTP.Method { get }
  var route: String { get }
  var headers: [String: String] { get }
  var body: HTTP.AnyEncodable? { get }
}
```

Using a protocol allows for endpoints to be created using conforming types which utilizes individual constructors based on user design. You can also opt-out of this by deciding to use the `AnyEndpoint` type.

`HTTPEndpoint` is generic over `ResponseType`, requiring `Decodable` conformance.

Thus the type signature for an endpoint is dependant on the expected response.
