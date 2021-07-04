//
//  SearchViewModel.swift
//  WookieMovies
//
//  Created by lee on 2021/1/26.
//

import Foundation
import RxCocoa
import RxSwift

class SearchViewModel {
    let apiManager: WMApiManager
    let disposeBag = DisposeBag()

    private let _movies = BehaviorRelay<[MovieViewModel]>(value: [])
    private let _isFetching = BehaviorRelay<Bool>(value: false)
    var isFetching: Driver<Bool> {
        return _isFetching.asDriver()
    }
    
    init(query: Driver<String>, api: WMApiManager) {
        apiManager = api
        query
            .throttle(RxTimeInterval.milliseconds(500))
            .distinctUntilChanged()
            .drive(onNext: { (queryString) in
                self.searchMovie(query: queryString)
                if queryString.isEmpty {
                    self._movies.accept([])
                }
            }).disposed(by: disposeBag)
    }
    
    var movies: Driver<[MovieViewModel]> {
        _movies.asDriver()
    }
    
    // MARK:- functions for the viewModel
    var numberOfMovies: Int {
        return _movies.value.count
    }
    
    func allMovies() -> [MovieViewModel] {
        return _movies.value
    }
    
    func searchMovie(query: String?) {
        guard let query = query, !query.isEmpty else {
            return
        }
        
        _movies.accept([])
        _isFetching.accept(true)
        
        print("query", query)

        apiManager.searchMovie(query: query) { res, error in
            self._isFetching.accept(false)
            guard let movies = res else {
                print(error as Any)
                self._movies.accept([])
                return
            }
            self._movies.accept(movies.map { MovieViewModel(movie: $0) })
        }
    }
    
    func removeSearched() {
        _movies.accept([])
    }
}
