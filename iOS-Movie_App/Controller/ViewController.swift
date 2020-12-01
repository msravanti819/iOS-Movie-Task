//
//  ViewController.swift
//Users/sravanti/Desktop/iOS-Movie_App/iOS-Movie_App/Controller/ViewController.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 27/11/20.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var SearchTextField: UITextField!
    
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBOutlet weak var OptionButton: UIButton!
    
    var cellIndex = 0
    var pageNo: Int = 1
    var totalPages: Int = 1
    
    //var searchData = [MovieData.Movie]()
      //For Movie search 

    
    let moviemanager = MovieManager()
    
    var data = [MovieData.Movie]()
    
    
    //var searchMovie = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.collectionViewLayout = UICollectionViewFlowLayout()
        collectionview.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.moviecell)
//        collectionview.backgroundColor = .white
//        view.backgroundColor = .lightGray
        moviemanager.performRequest(userpreffered: "now_playing") {
            (Bool,datach) in
            if Bool{
                self.data = datach.results
//                print(datach.results[0].originalTitle)
                //self.didUpdate(data)
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }

                
            }
            
            
        }
        
        
//        print(data[0].originalTitle)
    }
    
    
    func reinitializeData() {
       // searchData = []
        data = []
        totalPages = 1
        pageNo = 1
      }
    
    //later task
    @IBAction func SearchAction(_ sender: UIButton) {
    
    }
    
    
    
    
    @IBAction func optionButtonPressed(_ sender: UIButton) {
        //Shows options for movie list
        let alert = UIAlertController(title: "Select Options", message: "", preferredStyle: .alert)
        let topRated = UIAlertAction(title: "Top Rated", style: .default) { (action) in
            self.moviemanager.performRequest(userpreffered: "top_rated") { (Bool, data) in
                if Bool {
                    self.data = data.results
                }
            }
        }
        let nowPlaying = UIAlertAction(title: "Now Playing", style: .default) { (action) in
            self.moviemanager.performRequest(userpreffered: "now_playing") { (Bool, data) in
                if Bool {
                    self.data = data.results
                }
            }
        }
        
        let upComing = UIAlertAction(title: "Upcoming", style: .default) { (action) in
            self.moviemanager.performRequest(userpreffered: "upcoming") { (Bool, data) in
                if Bool {
                    self.data = data.results
                }
            }
        }
        
        let popular = UIAlertAction(title: "Popular", style: .default) { (action) in
            self.moviemanager.performRequest(userpreffered: "popular") { (Bool, data) in
                if Bool {
                    self.data = data.results
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        //Gives the user to operate
        alert.addAction(topRated)
        alert.addAction(popular)
        alert.addAction(nowPlaying)
        alert.addAction(upComing)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)

    }
    
}




        
extension ViewController: UICollectionViewDataSource {
   
    //MARK: - DataSource Methods

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(data?.results.count)
        return data.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            //let row = articles[indexPath.row];
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.moviecell, for: indexPath) as! MovieCollectionViewCell
        //cell.MovieName.text = "Silence"
        
        cell.MovieName.text = data[indexPath.row].title
        guard let posterPath = data[indexPath.row].posterPath else{return cell}
            cell.MovieImage.tag = indexPath.row
        cell.MovieImage.load(url: URL(string: Constants.imageURL + posterPath)!)
        return cell
        }
    
}

//For image storing long time
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
  func load(url: URL) {
    DispatchQueue.global().async { [weak self] in
      //ImageCache Implementation
      DispatchQueue.main.async {
        self!.image = nil
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
          self!.image = imageFromCache
          return
        }
      }
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            let imageToCache = image
            imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
            self!.image = image
          }
        }
      }
    }
  }
}


extension ViewController: UICollectionViewDelegate {
    
    //MARK: - Delegate Methods
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellIndex = indexPath.row
        performSegue(withIdentifier: Constants.segueIdentifier, sender: self)
          
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MovieDetails
//        vc.name = SearchTextField.text! //for trial
        
        vc.movieDetail = self.data[cellIndex]
        
        //not getting idea to pass the values
        
        
      }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Delegate Layout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 2

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//            return CGSize(width: 200.0, height: 200.0)
//        }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    }

//MARK: - TextfieldDelegate
    extension ViewController: UITextFieldDelegate {
      func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        SearchTextField.endEditing(true)
        return true
      }
      
      func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
          return true
        } else {
          return false
        }
      }
      //Implementing search API
      func textFieldDidEndEditing(_ textField: UITextField) {
//        if let query = SearchTextField.text {
//
//          DispatchQueue.main.async {
//            self.collectionview.reloadData()
//          }
//        }
//        SearchTextField.text = ""
      }
    
    }



    
    
    
    
    



