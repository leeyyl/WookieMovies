//
//  MovieDetailViewModel.swift
//  WookieMovies
//
//  Created by lee on 2021/1/26.
//

import UIKit

class MovieDetailViewModel {
    let defaultsManager: WMUserDefaults

    let movieId: String
    
    // MARK: - initializer for the viewModel
    init(movieId: String, defaults: WMUserDefaults) {
        self.movieId = movieId
        defaultsManager = defaults
    }
    
    // MARK: - functions for favorite movie
    func likePressed(movie: Movie) -> Bool {
        let buttonStatus = defaultsManager.toggleFavorites(movie: movie)
        if (buttonStatus) {
            return true
        } else {
            return false
        }
    }
    
    func checkIfFavorite(id: String) -> Bool {
        if (defaultsManager.checkIfFavorite(id: id)) {
            return true
        } else  {
            return false
        }
    }
}
