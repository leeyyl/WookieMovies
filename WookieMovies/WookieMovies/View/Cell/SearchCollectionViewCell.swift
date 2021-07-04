//
//  SearchCollectionViewCell.swift
//  WookieMovies
//
//  Created by lee on 2021/1/28.
//

import UIKit
import RxCocoa
import RxSwift

class SearchCollectionViewCell: UICollectionViewCell {
    let container = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let overviewLabel = UILabel()
    
    let duration: Double = 0.25

    var searchViewModel: SearchViewModel?
    let disposeBag = DisposeBag()
    
    var shimmer: ShimmerLayer = ShimmerLayer()
    
    var movie : Movie?
    
    override class func description() -> String {
        "SearchTableViewCell"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        hideViews()
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.setShadow(shadowColor: UIColor.label,
                            shadowOpacity: 0.25,
                            shadowRadius: 10,
                            offset: CGSize(width: 1, height: 1))
        contentView.addSubview(container)
        contentView.addSubview(imageView)
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        
        titleLabel.text = movie?.title
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        
        overviewLabel.text = movie?.overview
        overviewLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        overviewLabel.adjustsFontForContentSizeCategory = true
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let movieLabelStackView = UIStackView(arrangedSubviews: [titleLabel, overviewLabel])
        movieLabelStackView.axis = .vertical
        movieLabelStackView.alignment = .top
        movieLabelStackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(movieLabelStackView)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10),
            imageView.widthAnchor.constraint(equalToConstant: 90),
            
            movieLabelStackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            movieLabelStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10),
            movieLabelStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            movieLabelStackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        container.setShadow(shadowColor: UIColor.label,
                            shadowOpacity: 0.25,
                            shadowRadius: 10,
                            offset: CGSize(width: 1, height: 1))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hideViews()
    }
    
    // MARK:- animation functions
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: duration, delay: 0) {
            self.imageView.setOpacity(to: 0)
            self.titleLabel.setOpacity(to: 0)
            self.overviewLabel.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: duration, delay: 0) {
            self.imageView.setOpacity(to: 1)
            self.titleLabel.setOpacity(to: 1)
            self.overviewLabel.setOpacity(to: 1)
        }
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            self.shimmer.removeLayerIfExists(self)
            self.shimmer = ShimmerLayer(for: container, cornerRadius: 12)
            self.layer.addSublayer(self.shimmer)
        }
    }
    
    func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    
    // MARK:- functions for the cell
    func setupCell(viewModel: MovieViewModel) {
        setShimmer()
        let movie = viewModel.movie
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        
        viewModel.poster.drive(onNext: { (posterImage) in
            self.movie = movie
            DispatchQueue.main.async { [unowned self] in
                self.imageView.image = posterImage
                self.removeShimmer()
                self.showViews()
            }
        }).disposed(by: self.disposeBag)
    }
}
