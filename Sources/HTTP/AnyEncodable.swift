//
//  AnyEncodable.swift
//  HTTP
//
//  Created by Jackson Utsch on 3/24/22.
//

import Foundation

extension HTTP {
  /// A wrapper for any `Encodable`.
  public struct AnyEncodable: Encodable, Sendable {
    public let encodable: Encodable

    public init<T: Encodable>(_ encodable: T) {
      self.encodable = encodable
    }

    public func encode(to encoder: Encoder) throws {
      try encodable.encode(to: encoder)
    }
  }
}
