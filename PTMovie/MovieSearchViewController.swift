//
//  MovieSearchViewController.swift
//  PTMovie
//
//  Created by Jons on 2023/5/14.
//

import UIKit

class MovieSearchViewController: UIViewController {
    private let tableView = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private let movieDatabaseAPI = MovieDatabaseAPI(apiKey: "dc53e4d5fa18af9dfc76a64d5a3e9349")

    private var movies = [Movie]()

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
            movieDatabaseAPI.searchMovies(query: query) { [weak self] result in
                switch result {
                case .success(let movies):
                    DispatchQueue.main.async {
                        self?.movies = movies
                        self?.tableView.reloadData()
                    }
                case .failure(let error):
                    // Handle error
                    print("Error searching for movies: \(error.localizedDescription)")
                }
            }
        }

    private func showMovieDetails(forMovie movie: Movie) {
        let movieDetailsViewController = MovieDetailsViewController(movie: movie)
        navigationController?.pushViewController(movieDetailsViewController, animated: true)
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
