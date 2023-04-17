//
//  Errors.swift
//  HTTP
//
//  Created by Jackson Utsch on 3/24/22.
//

import Foundation

extension HTTP {
  /// The HTTP error type. Made generic using a custom error type for catching server formatted errors.
  public enum Errors<F: Error>: CustomStringConvertible, Hashable, LocalizedError, Sendable {
    case invalidURL
    case encoding(EncodingError)
    case decoding(DecodingError)
    case url(URLError)
    case caught(F)
    case uncaught(Error)

    public var description: String {
      switch self {
      case .invalidURL:
        return "invalidURL"
      case .encoding(let error):
        return "encoding(\(error))"
      case .decoding(let error):
        return "decoding(\(error))"
      case .url(let error):
        return "url(\(error))"
      case .caught(let error):
        return "caught(\(error))"
      case .uncaught(let error):
        return "uncaught(\(error))"
      }
    }

    public var errorDescription: String? {
      switch self {
      case .invalidURL:
        return NSLocalizedString(
          "HTTP.Errors.invalidURL", tableName: nil, bundle: .http, value: "", comment: "")
      case .encoding(let error):
        return error.localizedDescription
      case .decoding(let error):
        return error.localizedDescription
      case .url(let error):
        return error.localizedDescription
      case .caught(let error):
        return error.localizedDescription
      case .uncaught(let error):
        return error.localizedDescription
      }
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.errorDescription == rhs.errorDescription
    }

    public func hash(into hasher: inout Hasher) {
      hasher.combine(errorDescription)
    }
  }
}
