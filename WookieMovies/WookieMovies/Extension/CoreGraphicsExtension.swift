//
//  CoreGraphicsExtension.swift
//  WookieMovies
//
//  Created by lee on 2021/1/26.
//

import UIKit

extension CALayer {
    func removeLayerIfExists(_ view: UIView) {
        if let lastLayer = view.layer.sublayers?.last {
            let isPresent = lastLayer is ShimmerLayer
            if isPresent {
                self.removeFromSuperlayer()
            }
        }
    }
}
