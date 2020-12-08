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
    @IBOutlet weak var filterOption: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchLabel: UIButton!
    
    var cellIndex = 0
    var pageNo: Int = 1
    var totalPages: Int = 1
    let moviemanager = MovieManager()
    var data = [Movie]()
    var activityIndicator = UIActivityIndicatorView(style: .large) //Activity Indicator
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MovieApp"
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.collectionViewLayout = UICollectionViewFlowLayout()
        collectionview.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: Constants.moviecell)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        let lastFilterOrder = UserDefaults.standard.string(forKey: "Last Filter Order")
        updateData(userString: "top_rated", page: pageNo)
        optionCall(option: lastFilterOrder)
    }
    
    func updateData(userString: String, page: Int) {
        
        moviemanager.performRequest(userpreffered: userString, page: pageNo) { (Bool, datach) in
            if Bool {
                let lastIndex = self.data.count
                self.data.append(contentsOf: datach.results)
                self.totalPages = datach.totalPages
                    let indexPath: [IndexPath] = (0...19).map {IndexPath(row: lastIndex + $0, section: 0)}
                    DispatchQueue.main.async {
                     self.activityIndicator.stopAnimating()
                     self.collectionview.insertItems(at: indexPath)
                     self.collectionview.reloadItems(at: indexPath)
              }
           }
        }
    }
    //Reinitialising the Data
    func reinitializeData() {
        data = []
        totalPages = 1
        pageNo = 1
      }
    
    @IBAction func filterButtonPressed(_ sender: UIButton) {
        //Shows options for movie list
                let alert = UIAlertController(title: "Select Options", message: "", preferredStyle: .alert)
                let topRated = UIAlertAction(title: "Top Rated", style: .default) { (action) in
                    UserDefaults.standard.setValue("top_rated", forKey: "Last Filter Order")
                    self.optionCall(option: "top_rated")
                }
                let nowPlaying = UIAlertAction(title: "Now Playing", style: .default) { (action) in
                    UserDefaults.standard.setValue("now_playing", forKey: "Last Filter Order")
                    self.optionCall(option: "now_playing")
                }
        
                let upComing = UIAlertAction(title: "Upcoming", style: .default) { (action) in
                    UserDefaults.standard.setValue("upcoming", forKey: "Last Filter Order")
                    self.optionCall(option: "upcoming")
                }
        
                let popular = UIAlertAction(title: "Popular", style: .default) { (action) in
                    UserDefaults.standard.setValue("popular", forKey: "Last Filter Order")
                    self.optionCall(option: "popular")
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
            //For calling common function
            func optionCall(option: String?) {
                reinitializeData()
                updateData(userString: option ?? "top_rated", page: pageNo)
    }
    
    //API call for search Query
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        reinitializeData()
            moviemanager.fetchDataForQuery(query: searchTextField.text!, page: pageNo) { (Bool, data) in
                    self.data.append(contentsOf: data.results)
                    DispatchQueue.main.async {
                        self.collectionview.reloadData()
                    }
              }
       }
}
extension ViewController: UICollectionViewDataSource {
   
    //MARK: - DataSource Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.moviecell, for: indexPath) as? MovieCollectionViewCell else {return UICollectionViewCell()}
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
//MARK: - Delegate Methods
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellIndex = indexPath.row
        guard let vc = self.storyboard?.instantiateViewController(identifier: Constants.Controllers.MovieDetails) as? MovieDetails else {return}
        vc.movieDetail = data[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Display all images of particular url according to page number
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (data.count) - 1 {
           
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
        updateData(userString: "top_rated", page: pageNo)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    //MARK: - Delegate Layout Methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: (collectionView.frame.width - 20)/2, height: collectionView.frame.height/2)
        }
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        return CGSize(width: size, height: size+150)
        
    }

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
        searchTextField.endEditing(true)
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
        searchTextField.text = ""
      }
    }



    
    
    
    
    



