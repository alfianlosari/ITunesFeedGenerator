//
//  FeedResponse.swift
//  iTunesFeedGenerator
//
//  Created by Alfian Losari on 6/18/22.
//

import Foundation

struct FeedRootResponse<R: Codable>: Codable {
    let feed: Feed<R>
}

public struct Feed<R: Codable>: Codable {
    
    public let title: String
    public let id: String
    public let country: String
    public let icon: String
    public let updated: String
    public let results: [R]
}
