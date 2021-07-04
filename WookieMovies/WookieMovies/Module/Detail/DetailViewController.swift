//
//  DetailViewController.swift
//  WookieMovies
//
//  Created by lee on 2021/1/26.
//

import UIKit
import RxCocoa
import RxSwift

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var slugLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    let defaultsManager = WMUserDefaults()
    
    var movieViewModel: MovieViewModel!
    var detailViewModel: MovieDetailViewModel!
    
    var liked: ButtonConfiguration  = (symbol: "suit.heart.fill",
                                       configuration: UIImage.SymbolConfiguration(pointSize: 31, weight: .semibold, scale: .default),
                                       buttonTint: UIColor.systemPink)
    var normal: ButtonConfiguration  = (symbol: "suit.heart",
                                        configuration: UIImage.SymbolConfiguration(pointSize: 31, weight: .semibold, scale: .default),
                                        buttonTint: UIColor.tertiaryLabel)
    let factory: ButtonAnimationFactory = ButtonAnimationFactory()
    
    override class func description() -> String {
        "DetailViewController"
    }
    
    
    // MARK:- lifeCycle methods for the viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let viewModel = self.movieViewModel else { return }
        viewModel.backdrop.drive(onNext: { (image) in
            guard let backdropImage = image else { return }
            DispatchQueue.main.async { [unowned self] in
                self.imageView.image = backdropImage
            }
        }).disposed(by: disposeBag)
        
        let movie = viewModel.movie
        self.titleLabel.text = movie.title
        self.genresLabel.text = movie.genres.joined(separator: " | ")
        self.lengthLabel.text = movie.length
        let release = movie.released_on
        self.releaseLabel.text = String(release[release.startIndex..<release.firstIndex(of: "T")!])
        self.rateLabel.text = String(movie.imdb_rating)
        switch movie.director {
        case .string(let text):
            self.directorLabel.text = text
        case .array(let array):
            self.directorLabel.text = array.joined(separator: ", ")
        }
        self.castLabel.text = movie.cast.joined(separator: ", ")
        self.slugLabel.text = movie.slug
        self.textView.text = movie.overview
        
        detailViewModel = MovieDetailViewModel(movieId: movie.id, defaults: defaultsManager)

        self.setupView()
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        guard let viewModel = movieViewModel, let detailViewModel = detailViewModel else { return }
        let status = detailViewModel.likePressed(movie: viewModel.movie)
        if (status) {
            factory.makeActivateAnimation(for: favoriteButton, liked)
        } else {
            factory.makeDeactivateAnimation(for: favoriteButton, normal)
        }
    }
    
    // MARK:- utility functions for the viewController
    func setupView() {
        favoriteButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.75)
        favoriteButton.setCornerRadius(radius: self.favoriteButton.frame.width / 2 - 2)
        
        let movie = movieViewModel.movie
    
        titleLabel.text = movie.title
        
        if let status = self.detailViewModel?.checkIfFavorite(id: movie.id) {
            if (status) {
                self.setButton(with: liked)
            }
        }
    }
    
    func setButton(with config: ButtonConfiguration) {
        let image = UIImage(systemName: config.symbol, withConfiguration: config.configuration)
        self.favoriteButton.setImage(image, for: .normal)
        self.favoriteButton.tintColor = config.buttonTint
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
