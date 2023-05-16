//
//  MovieTableViewCell.swift
//  PTMovie
//
//  Created by Jons on 2023/5/14.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {

    // MARK: - Properties

    let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Initializers

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupViews() {
        contentView.addSubview(movieTitleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(posterImageView)

        let margin: CGFloat = 12.0

        NSLayoutConstraint.activate([
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
            posterImageView.widthAnchor.constraint(equalToConstant: 80.0),
            posterImageView.heightAnchor.constraint(equalToConstant: 120.0),

            movieTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: margin),
            movieTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            movieTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin),

            releaseDateLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: margin),
            releaseDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
            releaseDateLabel.topAnchor.constraint(equalTo: movieTitleLabel.bottomAnchor, constant: 8.0),
            releaseDateLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -margin)
        ])
    }

    // MARK: - Configuration

    func configure(with movie: Movie) {
        movieTitleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        
        posterImageView.image = nil
        let baseURL = "https://image.tmdb.org/t/p/w500"
        let posterURLString = baseURL + movie.posterPath
        let url = URL(string: posterURLString)
        posterImageView.kf.setImage(with: url)
        

    }

    override func prepareForReuse() {
        super.prepareForReuse()
        movieTitleLabel.text = nil
        releaseDateLabel.text = nil
        posterImageView.image = nil
    }
}

