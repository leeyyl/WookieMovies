//
//  FoudationExtension.swift
//  WookieMovies
//
//  Created by lee on 2021/1/26.
//

import Foundation

extension Double {
    // rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
