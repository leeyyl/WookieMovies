//
//  SearchViewController.swift
//  WookieMovies
//
//  Created by lee on 2021/1/25.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController: UIViewController {
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var searchViewModel: SearchViewModel!
    let disposeBag = DisposeBag()
    
    let resultViewController = ResultViewController()
    
    override class func description() -> String {
        "SearchViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultViewController.delegate = self
        navigationItem.searchController = UISearchController(searchResultsController: resultViewController)
        self.definesPresentationContext = true
        navigationItem.searchController?.definesPresentationContext = true
//        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
        navigationItem.searchController?.searchBar.sizeToFit()
        
//        navigationItem.searchController?.searchBar.subviews\[0\].subviews\[0\].removeFromSuperview()
        
        navigationItem.hidesSearchBarWhenScrolling = false
//        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchBar = navigationItem.searchController!.searchBar
        searchBar.placeholder = "Please input movie name"
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        searchBar.rx.cancelButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned searchBar] in
                searchBar.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        searchViewModel = SearchViewModel(query: searchBar.rx.text.orEmpty.asDriver(), api: WMApiManager())
        searchViewModel.movies.drive(onNext: {[unowned self] (_) in
            self.resultViewController.movies = searchViewModel.allMovies().map({ $0.movie })
        }).disposed(by: disposeBag)
        
        searchViewModel.isFetching.drive(indicatorView.rx.isAnimating).disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

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

extension SearchViewController: SearchResultsDelegate {
    func didClickResult(movie: Movie) {
        let viewController = storyboard?.instantiateViewController(withIdentifier: DetailViewController.description())
        guard let detailViewController = viewController as? DetailViewController else {
            return
        }
        detailViewController.movieViewModel = MovieViewModel(movie: movie)
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailViewController, animated: true)
        self.hidesBottomBarWhenPushed = false
    }
}
