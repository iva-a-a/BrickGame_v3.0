//
//  NetworkClient.swift
//  BrickGame
//
//  Created by Alena Ivanova on 04.02.2026.
//

import Foundation
import BrickGameAPI

public final class NetworkClient: Sendable {

    private let baseURL: URL
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
    }

    func get<T: Decodable>(_ endpoint: Endpoints, as: T.Type = T.self) async throws -> T {
        guard endpoint.method == HTTPMethod.get else {
            throw BrickGameClientError.invalidURL
        }
        return try await request(endpoint, body: Optional<Data>.none, as: T.self)
    }

    func post<T: Decodable, B: Encodable>(_ endpoint: Endpoints, body: B, as: T.Type = T.self) async throws -> T {
        guard endpoint.method == HTTPMethod.post else {
            throw BrickGameClientError.invalidURL
        }
        let data: Data
        do {
            data = try encoder.encode(body)
        } catch {
            throw BrickGameClientError.transport(error)
        }
        return try await request(endpoint, body: data, as: T.self)
    }

    func post<T: Decodable>(_ endpoint: Endpoints, as: T.Type = T.self) async throws -> T {
        return try await request(endpoint, body: Optional<Data>.none, as: T.self)
    }

    private func request<T: Decodable>(_ endpoint: Endpoints, body: Data?, as _: T.Type) async throws -> T {
        let cleanPath = endpoint.path.hasPrefix("/") ? String(endpoint.path.dropFirst()) : endpoint.path
        let url = baseURL.appendingPathComponent(cleanPath)

        var req = URLRequest(url: url)
        req.httpMethod = endpoint.method.rawValue
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        if let body {
            req.httpBody = body
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: req)
        } catch {
            throw BrickGameClientError.transport(error)
        }

        guard let http = response as? HTTPURLResponse else {
            throw BrickGameClientError.invalidResponse
        }

        if (200...299).contains(http.statusCode) {

            if data.isEmpty {
                if T.self == EmptyResponse.self {
                    return EmptyResponse() as! T
                }
                throw BrickGameClientError.decoding(
                    DecodingError.dataCorrupted(.init(
                        codingPath: [],
                        debugDescription: "Empty response body for \(T.self)"
                    ))
                )
            }

            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                throw BrickGameClientError.decoding(error)
            }
        }

        if let apiError = try? decoder.decode(ErrorMessage.self, from: data) {
            throw BrickGameClientError.server(status: http.statusCode, message: apiError.message)
        }
        let fallback = String(data: data, encoding: .utf8) ?? "Unknown server error"
        throw BrickGameClientError.server(status: http.statusCode, message: fallback)
    }
}
