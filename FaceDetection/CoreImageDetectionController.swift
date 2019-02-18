//
//  CoreImageDetectionController.swift
//  FaceVision
//
//  Created by 周辉 on 2019/2/16.
//  Copyright © 2019 FaiChou. All rights reserved.
//

import UIKit
import CoreImage

class CoreImageDetectionController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  var image: UIImage!
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = image
  }
  @IBAction func detact() {
    let personciImage = CIImage(image: image)!
    let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)!
    let faces = faceDetector.features(in: personciImage)
    let ciImageSize = personciImage.extent.size
    var transform: CGAffineTransform!
    transform = CGAffineTransform(scaleX: 1, y: -1)
    transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
//    switch image.imageOrientation {
//    case .up:
//      transform = CGAffineTransform(scaleX: 1, y: -1)
//      transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
//    case .right:
//      transform = CGAffineTransform(a: 0, b: 1, c: 1, d: 0, tx: 0, ty: 0)
//    default:
//      transform = CGAffineTransform(scaleX: 1, y: -1)
//      transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
//    }
    if faces.isEmpty == true  {
      let alert = UIAlertController(title: "没有检测到人脸", message: "请换照片再试试吧😁", preferredStyle: .alert)
      let action = UIAlertAction(title: "确定", style: .default) {
        [weak weakself = self ] action in
        weakself?.performSegue(withIdentifier: "dismissCIDetection", sender: self)
      }
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
    for face in faces as! [CIFaceFeature] {
      // Apply the transform to convert the coordinates
      var faceViewBounds = face.bounds.applying(transform)
      // Calculate the actual position and size of the rectangle in the image view
      let viewSize = imageView.bounds.size
      let scale = min(viewSize.width / ciImageSize.width,
                      viewSize.height / ciImageSize.height)
      let offsetX = (viewSize.width - ciImageSize.width * scale) / 2
      let offsetY = (viewSize.height - ciImageSize.height * scale) / 2
      faceViewBounds = faceViewBounds.applying(CGAffineTransform(scaleX: scale, y: scale))
      faceViewBounds.origin.x += offsetX
      faceViewBounds.origin.y += offsetY

      let haha = UIImageView(frame: faceViewBounds)
      haha.image = UIImage(named: "haha-2")
      imageView.addSubview(haha)
    }
  }
}
