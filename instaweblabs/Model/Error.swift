//
//  Error.swift
//  instaweblabs
//
//  Created by Ashish on 09/06/25.
//
import Foundation

enum NetworkError: LocalizedError, Identifiable {
    var id: String { localizedDescription }

    case invalidURL
    case noData
    case decodingError
    case serverError(Int)
    case underlying(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return "The provided URL is invalid."
        case .noData: return "No data was received from the server."
        case .decodingError: return "Failed to decode server response."
        case .serverError(let code): return "Server responded with status code \(code)."
        case .underlying(let error): return error.localizedDescription
        }
    }
}
