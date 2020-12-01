//
//  MovieDetails.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 28/11/20.
//

import Foundation
import UIKit
 
class MovieDetails: UIViewController {
    
    var movieDetail: MovieData.Movie?
    
   // var name = " "
   
    @IBOutlet weak var originalTitle: UILabel!
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    
    @IBOutlet weak var overview: UILabel!
    
    
    @IBOutlet weak var userRating: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    

    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        originalTitle.text = movieDetail?.originalTitle
        overview.text = movieDetail?.overview
        releaseDate.text = movieDetail?.releaseDate
        userRating.text = String((movieDetail?.voteAverage)!)
        guard let posterPath = movieDetail?.posterPath else{return}
        moviePoster.load(url: URL(string: Constants.imageURL + posterPath)!)
        
    }
    
    
    
}
