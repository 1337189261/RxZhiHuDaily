//
//  ImageUtil.swift
//  RxZhihuDaily
//
//  Created by chenhaoyu.1999 on 2020/8/31.
//  Copyright © 2020 陈浩宇. All rights reserved.
//

import UIKit

extension UIImage {
    
    func cropTo(widthHeightRatio: CGFloat) -> UIImage {
        let ratio = size.width / size.height
        if ratio > widthHeightRatio {
            let width = size.height * widthHeightRatio
            return crop(to: CGSize(width: width, height: size.height))
        } else {
            let height = size.width / widthHeightRatio
            return crop(to: CGSize(width: size.width, height: height))
        }
    }
    
    func crop(to:CGSize) -> UIImage {
        guard let cgimage = self.cgImage else { return self }
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        guard let newCgImage = contextImage.cgImage else { return self }
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        let cropAspect: CGFloat = to.width / to.height
        var cropWidth: CGFloat = to.width
        var cropHeight: CGFloat = to.height
        if to.width > to.height {
            cropWidth = contextSize.width
            cropHeight = contextSize.width / cropAspect
            posY = (contextSize.height - cropHeight) / 2
        } else if to.width < to.height {
            cropHeight = contextSize.height
            cropWidth = contextSize.height * cropAspect
            posX = (contextSize.width - cropWidth) / 2
        } else {
            if contextSize.width >= contextSize.height {
                cropHeight = contextSize.height
                cropWidth = contextSize.height * cropAspect
                posX = (contextSize.width - cropWidth) / 2
            }else{ //Square on portrait
                cropWidth = contextSize.width
                cropHeight = contextSize.width / cropAspect
                posY = (contextSize.height - cropHeight) / 2
            }
        }
        let rect: CGRect = CGRect(x: posX, y: posY, width: cropWidth, height: cropHeight)
        guard let imageRef: CGImage = newCgImage.cropping(to: rect) else { return self}
        let cropped: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        UIGraphicsBeginImageContextWithOptions(to, false, self.scale)
        cropped.draw(in: CGRect(x: 0, y: 0, width: to.width, height: to.height))
        let resized = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resized ?? self
      }
}
