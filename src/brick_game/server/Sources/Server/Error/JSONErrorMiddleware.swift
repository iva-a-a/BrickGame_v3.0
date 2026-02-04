//
//  JSONErrorMiddleware.swift
//  Server
//
//  Created by Alena Ivanova on 20.01.2026.
//


import Vapor
import BrickGameAPI

struct JSONErrorMiddleware: AsyncMiddleware {
    func respond(to request: Request, chainingTo next: any AsyncResponder) async throws -> Response {
        do {
            return try await next.respond(to: request)
        } catch let domain as BrickGameError {
            let res = Response(status: domain.status)
            try res.content.encode(ErrorMessage(message: domain.message))
            return res
        } catch let abort as any AbortError {
            let res = Response(status: abort.status)
            try res.content.encode(ErrorMessage(message: abort.reason))
            return res
        } catch {
            request.logger.report(error: error)
            let res = Response(status: .internalServerError)
            try res.content.encode(ErrorMessage(message: "Server error"))
            return res
        }
    }
}
