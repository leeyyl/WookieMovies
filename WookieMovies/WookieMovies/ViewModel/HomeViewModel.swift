//
//  HomeViewModel.swift
//  WookieMovies
//
//  Created by lee on 2021/1/26.
//

import UIKit
import RxCocoa
import RxSwift

class HomeViewModel {
    let defaultsManager: WMUserDefaults
    let apiManager: WMApiManager
    
    var genres = [String: [Movie]]()
    
    private let _movies = BehaviorRelay<[MovieViewModel]>(value: [])
    var movies: Driver<[MovieViewModel]> {
        _movies.asDriver()
    }
    
    // MARK:- initializer for the viewModel
    init(defaults: WMUserDefaults, api: WMApiManager) {
        defaultsManager = defaults
        apiManager = api
        
        // Getting movie list from the API
        apiManager.getMovies(completion: { (result, error) in
            guard let array = result else { return }
            for movie in array{
                let key = movie.genres[0]
                if var values = self.genres[key] {
                    values.append(movie)
                    self.genres[key] = values
                } else {
                    self.genres[key] = [movie]
                }
            }
            self._movies.accept(array.map { MovieViewModel(movie: $0) })
        })
//        if let url = Bundle.main.url(forResource: "MoviesData", withExtension:"json") {
//            do {
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                let response = try decoder.decode(QueryResponse.self, from: data)
//                for movie in response.movies {
//                    let key = movie.genres[0]
//                    if var values = genres[key] {
//                        values.append(movie)
//                        genres[key] = values
//                    } else {
//                        genres[key] = [movie]
//                    }
//                }
//                _movies.accept(response.movies.map { MovieViewModel(movie: $0) })
//            } catch {
//                print("error:\(error)")
//            }
//        }
    }
    
    // MARK:- functions for the viewModel

}
