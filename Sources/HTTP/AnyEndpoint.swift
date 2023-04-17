//
//  AnyEndpoint.swift
//  HTTP
//
//  Created by Jackson Utsch on 3/24/22.
//

import Foundation

extension HTTP {
  /// A wrapper for any `HTTPEndpoint`. To construct, a `HTTPEndpoint`
  /// type can be used or properties can be given directly in the initializer.
  public struct AnyEndpoint<V: Decodable>: HTTPEndpoint, Sendable {
    public typealias ResponseType = V
    public var method: Method
    public var route: String
    public var headers: [String: String]
    public var body: AnyEncodable?

    public init<T: HTTPEndpoint>(_ contents: T) {
      self.method = contents.method
      self.route = contents.route
      self.headers = contents.headers
      self.body = contents.body
    }

    public init(
      method: HTTP.Method,
      route: String,
      headers: [String: String] = [:],
      body: HTTP.AnyEncodable? = nil
    ) {
      self.method = method
      self.route = route
      self.headers = headers
      self.body = body
    }
  }
}
