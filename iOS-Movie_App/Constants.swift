//
//  Constants.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 27/11/20.
//

import Foundation
struct Constants {
    static let moviecell = "MovieCell"
    static let collectioncell = "MovieCollectionCell"
    static let apikey = "96dcfe9922c74f15d7256e7ce02ddfc3"
    static let mainURL = "https://api.themoviedb.org/3/movie/"
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    static let mainQueryURL = "https://api.themoviedb.org/3/search/movie"
    static var completeURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=196dcfe9922c74f15d7256e7ce02ddfc3" // For Now Playing
    static let ratingStar = "⭐️"
    static let segueIdentifier = "movieToDetails"
    struct  Controllers {
        static let MovieDetails = "MovieDetails"
    }
}
