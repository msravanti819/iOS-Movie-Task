//
//  ViewController.swift
//Users/sravanti/Desktop/iOS-Movie_App/iOS-Movie_App/Controller/ViewController.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 27/11/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionview: UICollectionView!
    
    @IBOutlet weak var SearchTextField: UITextField!
    
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBOutlet weak var OptionButton: UIButton!
    
    var cellIndex = 0
    var pageNo: Int = 1
    var totalPages: Int = 1  //By default for Now Playing
    
    let moviemanager = MovieManager()
    var data = [MovieData.Movie]()
    
    var activityIndicator = UIActivityIndicatorView(style: .large) //Activity Indicator for start and stop
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        collectionview.dataSource = self
        collectionview.delegate = self
        SearchTextField.delegate = self
        collectionview.collectionViewLayout = UICollectionViewFlowLayout()
        collectionview.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.moviecell)
//        collectionview.backgroundColor = .white
//        view.backgroundColor = .lightGray
        
       activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(activityIndicator)
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        moviemanager.performRequest(userpreffered: "now_playing" , page: pageNo) {
            (Bool,datach) in
            if Bool {
                
                self.data = datach.results
                self.totalPages = datach.totalPages
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.collectionview.reloadData()
                }

                
            }
            print("first page count = ",self.data.count)
            print("totalPages = ",self.totalPages)
            
            
        }
        
        

    }
    
    
    func reinitializeData() {
        data = []
        totalPages = 1
        pageNo = 1
      }
    
    //API call for search Query
    @IBAction func SearchAction(_ sender: UIButton) {
    
        moviemanager.fetchDataForQuery(query: SearchTextField.text!, page: pageNo) { (Bool, data) in
            self.data = data.results
            DispatchQueue.main.async {
                self.collectionview.reloadData()
            }
        }
        
    }
    
    
    
    
    @IBAction func optionButtonPressed(_ sender: UIButton) {
        //Shows options for movie list
        let alert = UIAlertController(title: "Select Options", message: "", preferredStyle: .alert)
        let topRated = UIAlertAction(title: "Top Rated", style: .default) { (action) in
            self.moviemanager.performRequest(userpreffered: "top_rated" , page: self.pageNo) { (Bool, data) in
                if Bool {
                    self.data = data.results
                    self.totalPages = data.totalPages
                    print("totalPages = ",self.totalPages)
                }
            }
        }
        let nowPlaying = UIAlertAction(title: "Now Playing", style: .default) { (action) in
            self.moviemanager.performRequest(userpreffered: "now_playing" , page: self.pageNo) { (Bool, data) in
                if Bool {
                    self.data = data.results
                    self.totalPages = data.totalPages
                    print("totalPages = ",self.totalPages)
                }
            }
        }
        
        let upComing = UIAlertAction(title: "Upcoming", style: .default) { (action) in
            self.moviemanager.performRequest(userpreffered: "upcoming" , page: self.pageNo) { (Bool, data) in
                if Bool {
                    self.data = data.results
                    self.totalPages = data.totalPages
                    print("totalPages = ",self.totalPages)
                }
            }
        }
        
        let popular = UIAlertAction(title: "Popular", style: .default) { (action) in
            self.moviemanager.performRequest(userpreffered: "popular" , page: self.pageNo) { (Bool, data) in
                if Bool {
                    self.data = data.results
                    self.totalPages = data.totalPages
                    print("totalPages = ",self.totalPages)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        
        //User to operate
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
        //print(data.count)
        return data.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            //let row = articles[indexPath.row];
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.moviecell, for: indexPath) as! MovieCollectionViewCell
        
        cell.contentView.addSubview(activityIndicator)//Activity Indicator started
        activityIndicator.startAnimating()
        
        
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
            self?.image = image
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
        vc.movieDetail = self.data[cellIndex]
        
        }
    
    //MARK: - Display all images of particular url according to page number
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == data.count - 1 {
        updateImagesWithPageNumber()
        }
      }
    //MARK: - Pagination
    func updateImagesWithPageNumber() {
        if pageNo <= totalPages {
          pageNo += 1
        } else {

          return
        }
        moviemanager.performRequest(userpreffered: "now_playing", page: pageNo) { (Bool, datach) in
            if Bool {
                self.data = datach.results
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            }
            
        }
        print("page count after changing page = ",data.count)
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Delegate Layout Methods
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//
//        let noOfCellsInRow = 2
//
//        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//
//        let totalSpace = flowLayout.sectionInset.left
//            + flowLayout.sectionInset.right
//            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
//
//        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
//
//        return CGSize(width: size, height: size)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 200.0, height: 350.0)
        }

//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
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
      
      func textFieldDidEndEditing(_ textField: UITextField) {
           // self.reinitializeData()
        SearchTextField.text = ""
      }
    
    }



    
    
    
    
    



