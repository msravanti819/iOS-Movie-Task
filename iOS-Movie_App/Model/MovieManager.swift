//
//  MovieManager.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 30/11/20.
//

import Foundation


enum urlError: Error {
  case httpError(code: String)
  case noData
  case other
  case apiError
  case invalidEndpoint
  case invalidResponse
  case decodeError
}

enum Result<T, urlError> {
  case success(T, Int?)
  case failure(urlError, Int?)
}
struct MovieManager {

        func performRequest(userpreffered: String, completion: @escaping (Bool,MovieData?) -> Void) {
            
            let urlstring = "https://api.themoviedb.org/3/movie/"+userpreffered+"?api_key=\(Constants.apikey)"
            //URL created
            if let url = URL(string: urlstring){
            
                //URL Session created
                let session = URLSession(configuration: .default)
                
                //create a URLSession Task or give a session task
                let task = session.dataTask(with: url) { (data, response, error) in //Anonymous function
                    
                    if error != nil{
                        print(error!)
    //                    self.delegate?.didFail(error: error)
                        completion(false,nil)
                        return
                    }
                    
                    if let safeData = data {
                       
                        if let decodedData = parseJSON(safeData) {
                           print(decodedData)
                            completion(true,decodedData)
                        }

                        
                    }
                    
              }
                
                //Start the task
                task.resume()
            }
            
        }
    
    
    
    
        
        func parseJSON(_ movieData: Data) -> MovieData? {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do{
                let decodedData = try decoder.decode(MovieData.self, from: movieData)
                return decodedData

              
               
            }catch{
                
                return nil
            }


        }
    
  }
