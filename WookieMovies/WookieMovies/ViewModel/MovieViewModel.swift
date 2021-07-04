//
//  MovieViewModel.swift
//  WookieMovies
//
//  Created by lee on 2021/1/26.
//

import UIKit
import RxCocoa
import RxSwift

class MovieViewModel {
    let fileManager: WMFileManager
    let apiManager: WMApiManager
    
    var movie: Movie
    
    let _poster = BehaviorRelay<UIImage?>(value: nil)
    let _backdrop = BehaviorRelay<UIImage?>(value: nil)
    let _favorite = BehaviorRelay<Bool?>(value: nil)


    init(movie: Movie, file: WMFileManager = WMFileManager(), api: WMApiManager = WMApiManager()) {
        self.movie = movie
        fileManager = file
        apiManager = api
        
        self.getMovieImage(imageType: .backdrop)
        self.getMovieImage(imageType: .poster)
    }
    
    var poster: Driver<UIImage?> {
        _poster.asDriver()
    }
    
    var backdrop: Driver<UIImage?> {
        _backdrop.asDriver()
    }
    
    var favorite: Driver<Bool?> {
        _favorite.asDriver()
    }
    
    func getMovieImage(imageType type: WMImageType) {
        if (fileManager.checkIfFileExists(id: movie.id, type: type)) {
            let file = fileManager.getPathForImage(id: movie.id, type: type).path
            switch type {
            case .backdrop:
                _backdrop.accept(UIImage(contentsOfFile: file))
            case .poster:
                _poster.accept(UIImage(contentsOfFile: file))
            }
        } else {
            var url: URL
            switch type {
            case .poster:
                url = movie.poster
            case .backdrop:
                url = movie.backdrop
            }
            apiManager.downloadImage(url: url, id: movie.id, type: type) { res, error in
                if (error == .none) {
                    let file = self.fileManager.getPathForImage(id: self.movie.id, type: type).path
                    switch type {
                    case .backdrop:
                        self._backdrop.accept(UIImage(contentsOfFile: file))
                    case .poster:
                        self._poster.accept(UIImage(contentsOfFile: file))
                    }
                }
            }
        }
    }
}
