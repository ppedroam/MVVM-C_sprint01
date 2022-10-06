//
//  Image+extensions.swift
//  mvvmcDevSprint
//
//  Created by Pedro Menezes on 22/09/22.
//

import Foundation
import UIKit

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func resized(toWidth width: CGFloat, isOpaque: Bool = false) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    
    func icon(size: Int) -> UIImage {
        let sizeValue = CGSize(width: size, height: size)
        return self.resize(targetSize: sizeValue)
    }
}


