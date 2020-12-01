//
//  MovieDetails.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 28/11/20.
//

import Foundation
import UIKit
 
class MovieDetails: UIViewController {
    
    var movieDetail: MovieData?
    
    var name = " "
   
    @IBOutlet weak var originalTitle: UILabel!
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    
    @IBOutlet weak var overview: UILabel!
    
    
    @IBOutlet weak var userRating: UILabel!
    
    @IBOutlet weak var releaseDate: UILabel!
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        overview.text = name
        
    }
    
    
    
}
