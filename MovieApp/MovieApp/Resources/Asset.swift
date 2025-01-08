//
//  Asset.swift
//  MovieApp
//
//  Created by Dmytro on 07.01.2025.
//
import UIKit

public enum Asset {
    internal static let primary = UIColor.primaryApp
    internal static let background = UIColor.backgroundApp
    internal static let overlayColor = UIColor.black.withAlphaComponent(0.2)

    internal static let sortImage = UIImage(resource: .sort).resize(newSize: .init(width: 20, height: 15))
    internal static let gallery = UIImage(resource: .gallery)
    internal static let calendar = UIImage(resource: .calendar)
    internal static let favorite = UIImage(resource: .favorite)
    internal static let back = UIImage(resource: .arrowLeft)
    internal static let close = UIImage(resource: .close)
    internal static let play = UIImage(resource: .play)
}

extension UIImage {
    func resize(size: CGFloat) -> UIImage {
        return resize(newSize: .init(width: size, height: size))
    }

    func resize(newSize: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage ?? self
    }
}
