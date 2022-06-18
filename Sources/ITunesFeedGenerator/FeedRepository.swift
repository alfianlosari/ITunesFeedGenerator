//
//  FeedRepository.swift
//  ITunesFeedGenerator
//
//  Created by Alfian Losari on 6/18/22.
//

import Foundation

public protocol FeedRepositoryInterface {
    func getMostPlayedSongsFeed(region: String, resultLimit: ResultLimit) async throws -> Feed<Song>
    func getTopAppsFeed(region: String, type: PricingType, resultLimit: ResultLimit) async throws -> Feed<Application>
    func getTopBooksFeed(region: String, type: PricingType, resultLimit: ResultLimit) async throws -> Feed<Book>
}

public struct FeedRepository: FeedRepositoryInterface {
    
    let baseURL: String
    private let session = URLSession.shared
    private let jsonDecoder = { JSONDecoder() }()
    
    public init(baseURL: String = "https://rss.applemarketingtools.com/api/v2") {
        self.baseURL = baseURL
    }
    
    public func getMostPlayedSongsFeed(region: String = "sg", resultLimit: ResultLimit = .limit25) async throws -> Feed<Song> {
        try await fetchFeed(urlString: baseURL + "/\(region)/music/most-played/\(resultLimit.rawValue)/songs.json")
    }
    
    public func getTopAppsFeed(region: String = "us", type: PricingType = .topFree, resultLimit: ResultLimit = .limit25) async throws -> Feed<Application> {
        try await fetchFeed(urlString: baseURL + "/\(region)/apps/\(type.rawValue)/\(resultLimit.rawValue)/apps.json")
    }
    
    public func getTopBooksFeed(region: String = "us", type: PricingType = .topPaid, resultLimit: ResultLimit = .limit25) async throws -> Feed<Book> {
        try await fetchFeed(urlString: baseURL + "/\(region)/books/\(type.rawValue)/\(resultLimit.rawValue)/books.json")
    }
    
    private func fetchFeed<D: Decodable>(urlString: String) async throws -> Feed<D> {
        guard let url = URL(string: urlString) else {
            throw StoreAPIRepositoryError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        try validateHTTPResponse(data: data, response: response)
        return try jsonDecoder.decode(FeedRootResponse<D>.self, from: data).feed
    }
    
    private func validateHTTPResponse(data: Data, response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw StoreAPIRepositoryError.invalidResponseType
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            let errorResponse = try? jsonDecoder.decode(ErrorResponse.self, from: data)
            throw StoreAPIRepositoryError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: errorResponse)
        }
    }
}

public enum ResultLimit: Int {
    case limit10 = 10
    case limit25 = 25
    case limit50 = 50
}

public enum PricingType: String {
    case topPaid = "top-paid"
    case topFree = "top-free"
}

public struct ErrorResponse: Codable {
    let status: String
    let error: String
}

public enum StoreAPIRepositoryError: CustomNSError {
    
    case invalidURL
    case invalidResponseType
    case httpStatusCodeFailed(statusCode: Int, error: ErrorResponse?)
    
    public static var errorDomain: String { "iTunesFeedGenerator" }
    public var errorCode: Int {
        switch self {
        case .invalidURL: return 1
        case .invalidResponseType: return 2
        case .httpStatusCodeFailed: return 2
        }
    }
    
    public var errorUserInfo: [String : Any] {
        let text: String
        switch self {
        case .invalidURL:
            text = "Invalid URL"
        case .invalidResponseType:
            text = "Invalid Response Type"
        case let .httpStatusCodeFailed(statusCode, error):
            if let error = error {
                text = "Error: Status Code\(error.status), message: \(error.error)"
            } else {
                text = "Error: Status Code \(statusCode)"
            }
        }
        
        return [NSLocalizedDescriptionKey: text]
    }
}
