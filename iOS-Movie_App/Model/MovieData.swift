//
//  MovieModel.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 29/11/20.
//

import Foundation
public struct MovieData: Codable {
    
    public let page: Int?
    public let totalResults: Int?
    public let totalPages: Int?
    public let results: [Movie]

public struct Movie: Codable {
    

    public let title: String?
    public let posterPath: String?
    public let overview: String?
    public let release_date: Date?
    public let original_title: String?
    public let vote_average: Int?
}
}
