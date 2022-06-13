//
//  HTTPEndpoint.swift
//  HTTP
//
//  Created by Jackson Utsch on 3/24/22.
//

import Foundation

public protocol HTTPEndpoint<ResponseType> where ResponseType: Decodable {
	associatedtype ResponseType
  var method: HTTP.Method { get }
  var route: String { get }
  var headers: [String: String] { get }
  var body: (any Encodable)? { get }
}
