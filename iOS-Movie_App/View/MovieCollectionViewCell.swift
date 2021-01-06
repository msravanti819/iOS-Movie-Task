//
//  MovieCollectionViewCell.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 27/11/20.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = nil
    }
}
