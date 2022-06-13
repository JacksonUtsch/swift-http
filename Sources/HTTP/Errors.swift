//
//  Errors.swift
//  HTTP
//
//  Created by Jackson Utsch on 3/24/22.
//

import Foundation

extension HTTP {
  /// The HTTP error type. Made generic using a custom error type for catching server formatted errors.
  public enum Errors<F: Error>: CustomStringConvertible, Hashable, LocalizedError {
    case invalidURL
    case encoding(EncodingError)
    case decoding(DecodingError)
    case url(URLError)
    case caught(F)
    case uncaught(Error)

    public var description: String {
      switch self {
      case .invalidURL:
        return "HTTP.Errors.invalidURL"
      case .encoding(let error):
        return "HTTP.Errors.encoding(\(error))"
      case .decoding(let error):
        return "HTTP.Errors.decoding(\(error))"
      case .url(let error):
        return "HTTP.Errors.url(\(error))"
      case .caught(let error):
        return "HTTP.Errors.caught(\(error))"
      case .uncaught(let error):
        return "HTTP.Errors.uncaught(\(error))"
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
        return String(describing: error)
      case .caught(let error):
        return String(describing: error)
      case .uncaught(let error):
        return String(describing: error)
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
