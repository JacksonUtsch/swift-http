//
//  Async.swift
//  HTTP
//
//  Created by Jackson Utsch on 3/24/22.
//

import Foundation
import URLSessionBackport

extension HTTP {
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
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

    let data = try await URLSession.shared.backport.data(for: request, delegate: .none).0

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

extension HTTP {
  @available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
  public static func asyncResult<E: HTTPEndpoint, F: Error>(
    at base: String,
    with endpoint: E,
    including standardHeaders: [String: String] = [:],
    catching: @escaping (Data) -> F?,
    dumping: Bool = false
  ) async -> Result<E.ResponseType, Errors<F>> {
    func dprint(_ contents: Any) {
      if dumping { print(contents) }
    }

    dprint("\n" + endpoint.method.value)
    dprint("URL: \(base + endpoint.route)")
    guard let url = URL(string: base + endpoint.route) else {
      return .failure(.invalidURL)
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
        return .failure(.encoding(error))
      } else {
        return .failure(.uncaught(error))
      }
    }

    var data: Data?
    do {
      let dataResult = try await URLSession.shared.backport.data(for: request, delegate: .none).0
      data = dataResult
    } catch let error as URLError {
      return .failure(.url(error))
    } catch {
      return .failure(.uncaught(error))
    }

    guard let data = data else { fatalError() }

    if let dataReps = String(data: data, encoding: .utf8) {
      dprint("Data as utf8")
      dprint(dataReps)
    } else {
      dprint("Unable to parse as utf8")
    }

    if let error = catching(data) {
      return .failure(.caught(error))
    }

    if E.ResponseType.self == Data.self {
      return .success(data as! E.ResponseType)
    }

    do {
      let response = try JSONDecoder().decode(E.ResponseType.self, from: data)
      return .success(response)
    } catch {
      if let error = error as? DecodingError {
        return .failure(Errors<F>.decoding(error))
      } else {
        return .failure(Errors<F>.uncaught(error))
      }
    }
  }
}
