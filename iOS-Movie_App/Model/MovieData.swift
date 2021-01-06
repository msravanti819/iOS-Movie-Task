//
//  MovieModel.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 29/11/20.
//

import Foundation

struct MovieData: Codable {
  var results: [Movie]
  let page, totalResults: Int?
  let totalPages: Int?
}
  // MARK: - Movie
   struct Movie: Codable {
    let popularity: Double?
    let voteCount: Int?
    let posterPath: String?
    let originalTitle: String?
    let title: String?
    let voteAverage: Double?
    let overview, releaseDate: String?

}
