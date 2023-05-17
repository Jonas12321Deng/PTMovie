//
//  MovieSearchViewController.swift
//  PTMovie
//
//  Created by Jons on 2023/5/14.
//

import UIKit
import SwiftyJSON

class MovieSearchViewController: UIViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let movieDatabaseAPI = MovieDatabaseAPI(apiKey: "dc53e4d5fa18af9dfc76a64d5a3e9349")

    private var movies = [Movie]()

    private var models = [MovieItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Movie Search"
        setupTableView()
        setupSearchController()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "MovieTableViewCell")
    }

    private func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchBar.placeholder = "Search for movies"
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
    }

    private func fetchMovies(withQuery query: String) {
        if NetworkManager.shared.isConnected() {
            // 网络正常，从后端接口获取数据
            movieDatabaseAPI.searchMovies(query: query) { [weak self] result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self?.movies = movies
                        self?.tableView.reloadData()
                        self?.saveSearchResultsToCoreData(movies: movies)
                    }
                case .failure(let error):
                    // 处理错误
                    print("Error searching for movies: \(error.localizedDescription)")
                }
            }
        } else {
            
            let cachedMovies = fetchCachedMoviesFromCoreData()
            if !cachedMovies.isEmpty {
                self.movies = cachedMovies
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    private func showNoInternetAlert() {
        let alert = UIAlertController(title: "No Internet Connection", message: "You are currently offline. Please check your network connection and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


    private func showMovieDetails(forMovie movie: Movie) {
        let movieDetailsViewController = MovieDetailsViewController(movie: movie)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    
    
    // MARK: - Core Data
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchCachedMoviesFromCoreData() -> [Movie] {
        do {
            let models = try context.fetch(MovieItem.fetchRequest())
            let movies = models.compactMap { model -> Movie? in
                guard let titleString = model.titleString,
                      let releaseStr = model.releaseStr,
                      let overViewStr = model.overViewStr else {
                    return nil
                }
                
                return Movie(id: Int(model.id), title: titleString, releaseDate: releaseStr, posterPath: "", overview: overViewStr)
            }
            return movies
        } catch {
            print("Failed to fetch cached movies from Core Data: \(error)")
            return []
        }
    }


    func saveSearchResultsToCoreData(movies: [Movie]) {
        
        for movie in movies {
            let newItem = MovieItem(context: context)
            newItem.titleString = movie.title
            newItem.id = Int64(movie.id)
            newItem.overViewStr = movie.overview
            newItem.releaseStr = movie.releaseDate
        }
        
        do {
            try context.save()
        }
        catch {
            print("Failed to save search results to Core Data: \(error)")
        }
        
    }
    
}

// MARK: - UITableViewDataSource

extension MovieSearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else {
            fatalError("Unable to dequeue MovieTableViewCell")
        }

        let movie = movies[indexPath.row]
        cell.configure(with: movie)

        return cell
    }
}

// MARK: - UITableViewDelegate

extension MovieSearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        showMovieDetails(forMovie: movie)
    }
}

// MARK: - UISearchResultsUpdating

extension MovieSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces), !query.isEmpty else {
            movies = []
            tableView.reloadData()
            return
        }

        fetchMovies(withQuery: query)
    }
}
