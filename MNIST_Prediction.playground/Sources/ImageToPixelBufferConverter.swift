//
//  ImageToPixelBufferConverter.swift
//  MNIST_Prediction (playground)
//
//  Created by Sergio Fraile on 7/31/19.
//  Copyright © 2019 Sergio Fraile. All rights reserved.
//

// NOTE: Unused, applied from Extensions.swift instead.

import Foundation
import UIKit

// MARK: - ImageToPixelBufferConverter

public class ImageToPixelBufferConverter {

  static public func convertToPixelBuffer(image: UIImage, withSize: CGSize?) -> CVPixelBuffer? {
    var resizedImage: UIImage?
    
    if let newSize = withSize, newSize != image.size {
      UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
      image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
      defer { UIGraphicsEndImageContext() }
      guard let imageFromGraphics = UIGraphicsGetImageFromCurrentImageContext() else {
        return nil
      }
      resizedImage = imageFromGraphics
    } else {
      resizedImage = image
    }
    
    guard let unwrappedResizedImage = resizedImage else { return nil }
    
    var pixelBuffer: CVPixelBuffer?
    
    let width = Int(unwrappedResizedImage.size.width)
    let height = Int(unwrappedResizedImage.size.height)
    
    CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, nil, &pixelBuffer)
    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    
    let colorspace = CGColorSpaceCreateDeviceGray()
    let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer!), width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: colorspace, bitmapInfo: 0)!
    
    guard let cg = unwrappedResizedImage.cgImage else {
      return nil
    }
    
    bitmapContext.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
    
    return pixelBuffer
  }
}
