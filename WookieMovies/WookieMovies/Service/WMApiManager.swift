//
//  WMApiManager.swift
//  WookieMovies
//
//  Created by lee on 2021/1/25.
//

import UIKit
import Alamofire

enum APIError: String {
    case networkError
    case apiError
    case decodingError
}

enum APIs: URLRequestConvertible  {
    case getMovies
    case searchMovie(query: String)
    
    var method: HTTPMethod {
        return .get
    }
    
    var encoding : URLEncoding {
        return URLEncoding.init(destination: .queryString, arrayEncoding: .noBrackets)
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: BASE_URL)
        var parameters = Parameters()
        switch self {
        case .searchMovie(let query):
            parameters["q"] = query
        case .getMovies:
            break
        }
        request.addValue(AUTH_HEADER, forHTTPHeaderField: "Authorization")
        request = try encoding.encode(request, with: parameters)
        return request
    }
}


struct WMApiManager {
    let jsonDecoder = JSONDecoder()
    let fileManager = WMFileManager()
    let imageCompressionScale: CGFloat = 0.25

    func downloadImage(url: URL, id: String, type: WMImageType, completion: @escaping(URL?, APIError?) -> ()) {
        AF.request(URLRequest(url: url)).validate().responseData { res in
            switch res.result {
            case .failure:
                completion(nil, .apiError)
            case .success(let imageData):
                guard let image = UIImage(data: imageData), let compressedData = image.jpegData(compressionQuality: self.imageCompressionScale) else { return }
                do {
                    try compressedData.write(to: self.fileManager.getPathForImage(id: id, type: type))
                    completion(self.fileManager.getPathForImage(id: id, type: type), nil)
                } catch {
                    print(error)
                    completion(nil, .decodingError)
                }
            }
        }
    }
    
    func getMovies(completion: @escaping([Movie]?, APIError?) -> ()) {
        AF.request(APIs.getMovies).validate().responseJSON { json in
            switch json.result {
            case .failure:
                completion(nil, .apiError)
                break
            case .success(let jsonData):
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys)  {
                    do {
                        let response = try self.jsonDecoder.decode(QueryResponse.self, from: jsonData)
                        completion(response.movies, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
    
    func searchMovie(query: String, completion: @escaping([Movie]?, APIError? ) -> ()) {
        AF.request(APIs.searchMovie(query: query)).validate().responseJSON { json in
            switch json.result {
            case .failure:
                completion(nil, .apiError)
            case .success(let jsonData):
                if let jsonData = try? JSONSerialization.data(withJSONObject: jsonData, options: .sortedKeys)  {
                    do {
                        let response = try self.jsonDecoder.decode(QueryResponse.self, from: jsonData)
                        completion(response.movies, nil)
                    } catch {
                        print(error)
                        completion(nil, .decodingError)
                    }
                } else {
                    completion(nil, .networkError)
                }
            }
        }
    }
}
