//
//  Movie.swift
//  WookieMovies
//
//  Created by lee on 2021/1/25.
//

import Foundation

struct Movie: Codable, Hashable {
    let id: String
    let title: String
    let cast: [String]
    let classification: String
    let director: DynamicJSONProperty
    let genres: [String]
    let imdb_rating: Double
    let length: String
    let overview: String
    let released_on: String
    let slug: String
    
    public var poster: URL {
        return URL(string: "https://wookie.codesubmit.io/static/posters/\(id).jpg")!
    }

    public var backdrop: URL {
        return URL(string: "https://wookie.codesubmit.io/static/backdrops/\(id).jpg")!
    }
    
    public static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum DynamicJSONProperty: Codable {
    case array([String])
    case string(String)

    init(from decoder: Decoder) throws {
        let container =  try decoder.singleValueContainer()

        // Decode the double
        do {
            let array = try container.decode([String].self)
            self = .array(array)
        } catch DecodingError.typeMismatch {
            // Decode the string
            let string = try container.decode(String.self)
            self = .string(string)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .array(let value):
            try container.encode(value)
        case .string(let value):
            try container.encode(value)
        }
    }
}
