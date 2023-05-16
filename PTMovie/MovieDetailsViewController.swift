//
//  MovieDetailViewController.swift
//  PTMovie
//
//  Created by Jons on 2023/5/14.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // 定义 UI 元素
    let titleLabel = UILabel()
    let releaseDateLabel = UILabel()
    let posterImageView = UIImageView()
    let overviewTextView = UITextView()
    // 定义要显示的电影
    var movie: Movie?
    init(movie: Movie) {
            self.movie = movie
            super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        // 设置 UI 元素的属性
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        releaseDateLabel.font = UIFont.systemFont(ofSize: 16)
        releaseDateLabel.textColor = .gray
        posterImageView.contentMode = .scaleAspectFit
        overviewTextView.font = UIFont.systemFont(ofSize: 16)
        overviewTextView.isEditable = false
        overviewTextView.isSelectable = false
        
        // 将 UI 元素添加到视图中
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(posterImageView)
        view.addSubview(overviewTextView)
        
        // 设置 UI 元素的布局
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        releaseDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        releaseDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        posterImageView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8).isActive = true
        posterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        posterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        posterImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        overviewTextView.translatesAutoresizingMaskIntoConstraints = false
        overviewTextView.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 8).isActive = true
        overviewTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        overviewTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        overviewTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 从上一个视图控制器中获取电影信息，并更新 UI 元素
        if let movie = movie {
            titleLabel.text = movie.title
            releaseDateLabel.text = "Release Date: \(String(describing: movie.releaseDate))"
            if let posterUrl = URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath)") {
                posterImageView.kf.setImage(with: posterUrl)
            }
            overviewTextView.text = movie.overview
        }
    }
}
