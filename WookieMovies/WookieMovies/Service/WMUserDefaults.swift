//
//  WMUserDefaults.swift
//  WookieMovies
//
//  Created by lee on 2021/1/25.
//

import Foundation

class WMUserDefaults {
    // MARK:- get
    func getFavorites() -> [Movie] {
        guard let data = UserDefaults.standard.data(forKey: WM_FAVORITES_KEY)  else { return [] }
        var favorites = [Movie]()
        do {
            favorites = try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print(error)
        }
        return favorites
    }
    
    // MARK:- set
    func setFavorites(movies: [Movie]) {
        do {
            let data: Data = try JSONEncoder().encode(movies)
            UserDefaults.standard.set(data, forKey: WM_FAVORITES_KEY)
        } catch {
            print(error)
        }
    }
    
    
    // MARK:- favorite
    @discardableResult
    func toggleFavorites(movie: Movie) -> Bool {
        var favorites = getFavorites()
        let exists = favorites.filter({ $0.id == movie.id })
        if (exists.count > 0) {
            self.removeFromFavorites(movie: exists[0], favorites: favorites)
            return false
        } else {
            favorites.append(movie)
            self.setFavorites(movies: favorites)
            return true
        }
    }
    
    @discardableResult
    func checkIfFavorite(id: String) ->Bool {
        let favorites = getFavorites()
        let exists = favorites.filter({ $0.id == id })
        if exists.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    @discardableResult
    func removeFromFavorites(movie: Movie, favorites: [Movie]) -> Bool {
        self.setFavorites(movies: favorites.filter({ $0.id != movie.id }))
        return true
    }
    
    func clearUserDefaults() {
        UserDefaults.resetStandardUserDefaults()
    }
}
