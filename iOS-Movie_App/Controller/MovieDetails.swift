//
//  MovieDetails.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 28/11/20.
//

import Foundation
import UIKit
class MovieDetails: UIViewController {
    var movieDetail: Movie?
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var movieReview: UILabel!
    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var originalTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let movieDetail = movieDetail else {return}
        movieTitle.text = movieDetail.title
        originalTitle.text = movieDetail.originalTitle
        movieReview.text = movieDetail.overview
        releaseDate.text = movieDetail.releaseDate
        let rating = String((movieDetail.voteAverage!))
        movieRating.text = Constants.ratingStar + rating + "/10"
        guard let posterPath = movieDetail.posterPath else {return}
        moviePoster.kf.indicatorType = .activity
        moviePoster.kf.setImage(with: URL(string: Constants.imageURL + posterPath))
    }
}
