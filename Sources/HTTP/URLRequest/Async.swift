//
//  Async.swift
//  HTTP
//
//  Created by Jackson Utsch on 3/24/22.
//

import Foundation

extension HTTP {
  @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
  public static func async<E: HTTPEndpoint, F: Error>(
    at base: String,
    with endpoint: E,
    including standardHeaders: [String: String] = [:],
    catching: @escaping (Data) -> F?,
    dumping: Bool = false
  ) async throws -> E.ResponseType {
    func dprint(_ contents: Any) {
      if dumping { print(contents) }
    }

    dprint("\n" + endpoint.method.value)
    dprint("URL: \(base + endpoint.route)")
    guard let url = URL(string: base + endpoint.route) else {
      throw Errors<F>.invalidURL
    }

    var request = URLRequest(url: url)
    do {
      request.httpMethod = endpoint.method.value
      request.allHTTPHeaderFields = endpoint.headers.merging(
        standardHeaders, uniquingKeysWith: { (first, _) in first })

      if let body = endpoint.body {
        request.httpBody = try JSONEncoder().encode(body)
      }

      dprint("Headers: " + request.allHTTPHeaderFields!.description)
      if let body = request.httpBody {
        dprint("Body: " + String(data: body, encoding: .utf8)!)
      }

      dprint("\n")
    } catch {
      if let error = error as? EncodingError {
        throw Errors<F>.encoding(error)
      } else {
        throw Errors<F>.uncaught(error)
      }
    }

    let data = try await URLSession.shared.data(for: request, delegate: .none).0

    if let dataReps = String(data: data, encoding: .utf8) {
      dprint("Data as utf8")
      dprint(dataReps)
    } else {
      dprint("Unable to parse as utf8")
    }

    if let error = catching(data) {
      throw Errors.caught(error)
    }

    if E.ResponseType.self == Data.self {
      return data as! E.ResponseType
    }

    do {
      let response = try JSONDecoder().decode(E.ResponseType.self, from: data)
      return response
    } catch {
      if let error = error as? DecodingError {
        throw Errors<F>.decoding(error)
      } else {
        throw Errors<F>.uncaught(error)
      }
    }
  }
}
