//
//  MovieDatabaseAPI.swift
//  PTMovie
//
//  Created by Jons on 2023/5/15.
//

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

struct Movie {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String
    let overview: String
    
    init(json: JSON) {
        id = json["id"].intValue
        title = json["title"].stringValue
        releaseDate = json["release_date"].stringValue
        posterPath = json["poster_path"].stringValue
        overview = json["overview"].stringValue
    }
    
    init(id: Int, title: String, releaseDate: String, posterPath: String, overview: String) {
            self.id = id
            self.title = title
            self.releaseDate = releaseDate
            self.posterPath = posterPath
            self.overview = overview
        }
}

import Foundation
import SwiftyJSON

class MovieDatabaseAPI {
    private let apiKey: String
    private let baseURL = "https://api.themoviedb.org/3"

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func searchMovies(query: String, page: Int, completion: @escaping (Result<[Movie], Error>) -> Void) {
        let urlString = "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(query)&page=\(page)"

        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                completion(.failure(NetworkError.requestFailed))
                return
            }

            guard response.statusCode == 200 else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }

            do {
                let json = try JSON(data: data)
                let movieArray = json["results"].arrayValue
                let movies = movieArray.map { Movie(json: $0) }
                completion(.success(movies))
            } catch {
                completion(.failure(NetworkError.invalidData))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case invalidData
}
