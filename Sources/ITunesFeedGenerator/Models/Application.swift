//
//  Application.swift
//  iTunesFeedGenerator
//
//  Created by Alfian Losari on 6/18/22.
//

import Foundation

public struct Application: Codable {
    
    public let artistName: String
    public let id: String
    public let name: String
    public let releaseDate: String
    public let kind: String
    public let artworkUrl100: String
    public let url: String
}
