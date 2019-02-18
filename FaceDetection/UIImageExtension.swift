//
//  UIImageExtension.swift
//  FaceDetection
//
//  Created by 周辉 on 2019/2/18.
//  Copyright © 2019 FaiChou. All rights reserved.
//

import UIKit

extension UIImage {
  func rotate(radians: CGFloat) -> UIImage {
    let rotatedSize = CGRect(origin: .zero, size: size)
      .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
      .integral.size
    UIGraphicsBeginImageContext(rotatedSize)
    if let context = UIGraphicsGetCurrentContext() {
      let origin = CGPoint(x: rotatedSize.width / 2.0,
                           y: rotatedSize.height / 2.0)
      context.translateBy(x: origin.x, y: origin.y)
      context.rotate(by: radians)
      draw(in: CGRect(x: -origin.x, y: -origin.y,
                      width: size.width, height: size.height))
      let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
      
      return rotatedImage ?? self
    }
    
    return self
  }
  func rotateToPortrait(for orientation: UIImage.Orientation) -> UIImage {
    print(orientation.rawValue)
    switch orientation {
    case .up:
      return self
    case .right:
      return self.rotate(radians: .pi/2)
    case .left:
      return self.rotate(radians: -.pi/2)
    case .down:
      return self.rotate(radians: .pi)
    default:
      return self
    }
  }
}
