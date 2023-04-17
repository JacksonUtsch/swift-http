//
//  Method.swift
//  HTTP
//
//  Created by Jackson Utsch on 3/24/22.
//

import Foundation

extension HTTP {
  public enum Method: String, Codable, Sendable {
    case get, head, post, put, delete, connect, options, trace, patch

    public var value: String {
      switch self {
      case .get: return "GET"
      case .head: return "HEAD"
      case .post: return "POST"
      case .put: return "PUT"
      case .delete: return "DELETE"
      case .connect: return "CONNECT"
      case .options: return "OPTIONS"
      case .trace: return "TRACE"
      case .patch: return "PATCH"
      }
    }
  }
}
