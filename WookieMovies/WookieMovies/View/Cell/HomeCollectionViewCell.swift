//
//  SearchViewController.swift
//  WookieMovies
//
//  Created by lee on 2021/1/25.
//

import UIKit
import RxCocoa
import RxSwift

class HomeCollectionViewCell: UICollectionViewCell {
    let container = UIView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    
    // MARK:- variables for the cell
    override class func description() -> String {
        return "HomeCollectionViewCell"
    }
    
    let disposeBag = DisposeBag()
    
    let cellHeight: CGFloat = 240
    let cornerRadius: CGFloat = 12
    
    let animationDuration: Double = 0.25
    var shimmer: ShimmerLayer = ShimmerLayer()
    
    // MARK:- lifeCycle methods for the cell
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.hideViews()
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(container)
        contentView.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.setShadow(shadowColor: UIColor.label,
                                  shadowOpacity: 1,
                                  shadowRadius: 10,
                                  offset: CGSize(width: 0, height: 2))
        
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 4
        container.addSubview(imageView)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        titleLabel.adjustsFontForContentSizeCategory = true
        container.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
        ])
        
        titleLabel.setContentHuggingPriority(UILayoutPriority(252), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- delegate functions for collectionView
    func hideViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.titleLabel.setOpacity(to: 0)
        }
    }
    
    func showViews() {
        ViewAnimationFactory.makeEaseOutAnimation(duration: animationDuration, delay: 0) {
            self.titleLabel.setOpacity(to: 1)
        }
    }
    
    func setShimmer() {
        DispatchQueue.main.async { [unowned self] in
            self.shimmer.removeLayerIfExists(self)
            self.shimmer = ShimmerLayer(for: imageView, cornerRadius: 12)
            self.layer.addSublayer(self.shimmer)
        }
    }
    
    func removeShimmer() {
        shimmer.removeFromSuperlayer()
    }
    
    // MARK:- functions for the cell
    func setupCell(viewModel: MovieViewModel) {
        setShimmer()
        titleLabel.text = viewModel.movie.title
        
        viewModel.poster.drive(onNext: { (image) in
            guard let posterImage = image else { return }
            DispatchQueue.main.async { [unowned self] in
                self.imageView.image = posterImage
                self.removeShimmer()
                self.showViews()
            }
        }).disposed(by: disposeBag)
    }
}
