//
//  ViewController.swift
//  FaceVision
//
//  Created by 周辉 on 2019/2/15.
//  Copyright © 2019 FaiChou. All rights reserved.
//

import UIKit

enum FaceDetectionType: Int {
  case CoreImage = 1001
  case Vision = 1000
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var takePhotoButton: UIButton!
  var image: UIImage!
  var type: FaceDetectionType = .Vision
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  @IBAction func takePhoto(_ sender: UIButton) {
    let picker = UIImagePickerController()
    picker.delegate = self
    type = FaceDetectionType(rawValue: sender.tag) ?? .Vision
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      alert.addAction(UIAlertAction(title: "拍照", style: .default, handler: {action in
        picker.sourceType = .camera
        self.present(picker, animated: true, completion: nil)
      }))
    }
    alert.addAction(UIAlertAction(title: "相册", style: .default, handler: { action in
      picker.sourceType = .photoLibrary
      // on iPad we are required to present this as a popover
      if UIDevice.current.userInterfaceIdiom == .pad {
        picker.modalPresentationStyle = .popover
        picker.popoverPresentationController?.sourceView = self.view
        picker.popoverPresentationController?.sourceRect = self.takePhotoButton.frame
      }
      self.present(picker, animated: true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
    // on iPad this is a popover
    alert.popoverPresentationController?.sourceView = self.view
    alert.popoverPresentationController?.sourceRect = takePhotoButton.frame
    self.present(alert, animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    dismiss(animated: true, completion: nil)
    image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
    switch type {
    case .CoreImage:
      performSegue(withIdentifier: "detectByCoreImageSegue", sender: self)
    case .Vision:
      performSegue(withIdentifier: "detectByVisionSegue", sender: self)
    }
  }
  @IBAction func exit(unwindSegue: UIStoryboardSegue) {
    image = nil
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "detectByVisionSegue" {
      if let imageViewController = segue.destination as? VisionDetectionController {
        imageViewController.image = self.image
      }
    } else if segue.identifier == "detectByCoreImageSegue" {
      if let imageViewController = segue.destination as? CoreImageDetectionController {
        let imageUp = UIImage(cgImage: self.image.cgImage!, scale: self.image.scale, orientation: .up)
        imageViewController.image = imageUp.rotateToPortrait(for: self.image.imageOrientation)
      }
    }
  }
}

