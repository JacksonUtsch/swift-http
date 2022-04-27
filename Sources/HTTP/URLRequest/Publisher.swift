//
//  Publisher.swift
//  HTTP
//
//  Created by Jackson Utsch on 4/27/22.
//

import Combine
import Foundation

extension HTTP {
	@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
	public static func publisher<E: HTTPEndpoint, F: Error>(
		at base: String,
		with endpoint: E,
		including standardHeaders: [String: String] = [:],
		catching: @escaping (Data) -> F?,
		dumping: Bool = false
	) -> AnyPublisher<E.ResponseType, Errors<F>> {
		func dprint(_ contents: Any) {
			if dumping { print(contents) }
		}

		dprint("\n" + endpoint.method.value)
		dprint("URL: \(base + endpoint.route)")
		guard let url = URL(string: base + endpoint.route) else {
			return Result.Publisher(.failure(.invalidURL)).eraseToAnyPublisher()
		}

		var request = URLRequest(url: url)
		do {
			request.httpMethod = endpoint.method.value
			request.allHTTPHeaderFields = endpoint.headers.merging(standardHeaders, uniquingKeysWith: { (first, _) in first })

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
				return Result.Publisher(.failure(.encoding(error)))
					.eraseToAnyPublisher()
			} else {
				return Result.Publisher(.failure(.uncaught(error)))
					.eraseToAnyPublisher()
			}
		}

		return URLSession.shared.dataTaskPublisher(for: request)
			.tryMap { output -> Data in
				if let dataReps = String(data: output.data, encoding: .utf8) {
					dprint("Data as utf8")
					dprint(dataReps)
				} else {
					dprint("Unable to parse as utf8")
				}
				return output.data
			}
			.tryMap { data in
				if let error = catching(data) {
					throw Errors.caught(error)
				}
				return data
			}
			.decode(type: E.ResponseType.self, decoder: JSONDecoder())
			.mapError({ (error: Error) -> Error in
				if let error = error as? URLError {
					return Errors<F>.urlError(error)
				}
				return error
			})
			.mapError { error in
				if let error = error as? Errors<F> {
					return error
				} else {
					return .uncaught(error)
				}
			}
			.eraseToAnyPublisher()
	}
}
