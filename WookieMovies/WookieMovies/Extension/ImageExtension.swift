//
//  ImageExtension.swift
//  WookieMovies
//
//  Created by lee on 2021/1/26.
//

import UIKit

extension UIImage {
    class func backgroundImageWithColor(color: UIColor, size: CGSize, cornerRadius : CGFloat = 4.0) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        path.fill()
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
