//
//  ImageViewController.swift
//  FaceVision
//
//  Created by 周辉 on 2019/2/15.
//  Copyright © 2019 FaiChou. All rights reserved.
//

import UIKit
import Vision

class VisionDetectionController: UIViewController {
  @IBOutlet weak var imageView: UIImageView!
  
  var image: UIImage!
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.image = image
  }
  
  @IBAction func process(_ sender: UIButton) {
    var orientation: CGImagePropertyOrientation!
    
    // detect image orientation, we need it to be accurate for the face detection to work
    switch image.imageOrientation {
    case .up:
      orientation = .up
    case .right:
      orientation = .right
    case .down:
      orientation = .down
    case .left:
      orientation = .left
    default:
      orientation = .up
    }
    
    // vision
    let faceLandmarksRequest = VNDetectFaceLandmarksRequest(completionHandler: self.handleFaceFeatures)
    let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, orientation: orientation, options: [:])
    do {
      try requestHandler.perform([faceLandmarksRequest])
    } catch {
      print(error)
    }
  }
  func handleFaceFeatures(request: VNRequest, errror: Error?) {
    guard let observations = request.results as? [VNFaceObservation] else {
      fatalError("unexpected result type!")
    }
    
    if observations.isEmpty == false  {
      addEmojiTo(observations)
    } else {
      let alert = UIAlertController(title: "没有检测到人脸", message: "请换照片再试试吧😁", preferredStyle: .alert)
      let action = UIAlertAction(title: "确定", style: .default) {
        [weak weakself = self ] action in
        weakself?.performSegue(withIdentifier: "dismissVisionDetection", sender: self)
      }
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
  }
  func addEmojiTo(_ faces: [VNFaceObservation]) {
    UIGraphicsBeginImageContextWithOptions(image.size, true, 0.0)
    let context = UIGraphicsGetCurrentContext()
    
    // draw the image
    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    
    context?.translateBy(x: 0, y: image.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)
    
    for face in faces {
      // face rect
      let w = face.boundingBox.size.width * image.size.width
      let h = face.boundingBox.size.height * image.size.height
      let x = face.boundingBox.origin.x * image.size.width
      let y = face.boundingBox.origin.y * image.size.height
      let faceRect = CGRect(x: x, y: y, width: w, height: h)
//      context?.saveGState()
//      context?.setStrokeColor(UIColor.red.cgColor)
//      context?.setLineWidth(8.0)
//      context?.addRect(faceRect)
//      context?.drawPath(using: .stroke)
//      context?.restoreGState()
//      let transform = CGAffineTransform(scaleX: 1, y: -1)
//      let reactAdjust = faceRect.applying(transform)
      UIImage(named: "haha")?.draw(in: faceRect)
//      "😀".draw(in: faceRect, withAttributes: [.font: UIFont.systemFont(ofSize: faceRect.size.height)])
    }
    
    // get the final image
    let finalImage = UIGraphicsGetImageFromCurrentImageContext()
    
    // end drawing context
    UIGraphicsEndImageContext()
    
    imageView.image = finalImage
  }
}
