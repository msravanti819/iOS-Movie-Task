//
//  MovieManager.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 30/11/20.
//

import Foundation
struct MovieManager {

func performRequest(userpreffered: String,page: Int, completion: @escaping (Bool, MovieData) -> Void) {

  let urlstring =   "https://api.themoviedb.org/3/movie/"+userpreffered+"?api_key=\(Constants.apikey)&page=\(page)"
            //URL created
  if let url = URL(string: urlstring) {
                //URL Session created
   let session = URLSession(configuration: .default)
                //create a URLSession Task or give a session task
    let task = session.dataTask(with: url) { (data, response, error) in //Anonymous function
     if error != nil {
       return
        }
   if let safeData = data {
    if let decodedData = parseJSON(safeData) {
          completion(true,decodedData)
            }
            }
            }
                task.resume() //Start the task from suspended mode
            }
        }
    //For Query by user entered at textfield
    func fetchDataForQuery(query: String,page: Int, completion: @escaping (Bool, MovieData) -> Void){
        let urlstring = Constants.mainQueryURL+"?api_key=\(Constants.apikey)"+"&query="+query
        let urlString = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)        //For Removing Spaces in query
        if let url = URL(string: urlString!) {
            //URL Session created
        let session = URLSession(configuration: .default)
            //create a URLSession Task or give a session task
        let task = session.dataTask(with: url) { (data, response, error) in //Anonymous function
        if error != nil{
        //completion(false,nil)
            return
        }
        if let safeData = data {
            if let decodedData = parseJSON(safeData) {
                completion(true,decodedData)
            }
           }
          }
        task.resume()//Start the task from suspended mode
        }
    }
    
    //parseJSON calling for loading movie and also for query on textfield
        func parseJSON(_ movieData: Data) -> MovieData? {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do{
                let decodedData = try decoder.decode(MovieData.self, from: movieData)
                return decodedData
            } catch {
                
                return nil
            }
        }
  }
