//
//  ViewController.swift
//  CoreImageFilter
//
//  Created by iMac on 03/12/19.
//  Copyright © 2019 Mayur. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    // MARK:- Outlet
    @IBOutlet var imageView: UIImageView?
    
    // MARK:- View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK:- Other Method
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView?.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK:- IBAction
    @IBAction func btnAdd(_ sender: Any) {
        let imageController = UIImagePickerController()
        imageController.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
        imageController.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imageController,animated: true,completion: nil)
    }
    
    @IBAction func btnFilter(_ sender: Any) {
        guard let image = imageView?.image, let cgimg = image.cgImage else {
            let alertController = UIAlertController(title: "Select Image", message: "Please Select Image From Add '+' Button at top right corner.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        let coreImage = CIImage(cgImage: cgimg)
        let sepiaFilter = CIFilter(name: "CISepiaTone")
        sepiaFilter?.setValue(coreImage, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(0.5, forKey: kCIInputIntensityKey)
        if let sepiaOutput = sepiaFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let exposureFilter = CIFilter(name: "CIExposureAdjust")
            exposureFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
            exposureFilter?.setValue(1, forKey: kCIInputEVKey)
            if let exposureOutput = exposureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let output = context.createCGImage(exposureOutput, from: exposureOutput.extent)
                let result = UIImage(cgImage: output!)
                imageView?.image = result
            }
        }
    }
    
    @IBAction func btnAdvanceFilter(_ sender: Any) {
        guard let image = imageView?.image, let cgimg = image.cgImage else {
            let alertController = UIAlertController(title: "Select Image", message: "Please Select Image From Add '+' Button at top right corner.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let openGLContext = EAGLContext(api: .openGLES2)
        let context = CIContext(eaglContext: openGLContext!)
        let coreImage = CIImage(cgImage: cgimg)
        let sepiaFilter = CIFilter(name: "CISepiaTone")
        sepiaFilter?.setValue(coreImage, forKey: kCIInputImageKey)
        sepiaFilter?.setValue(1, forKey: kCIInputIntensityKey)
        if let sepiaOutput = sepiaFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
            let exposureFilter = CIFilter(name: "CIExposureAdjust")
            exposureFilter?.setValue(sepiaOutput, forKey: kCIInputImageKey)
            exposureFilter?.setValue(1, forKey: kCIInputEVKey)
            if let exposureOutput = exposureFilter?.value(forKey: kCIOutputImageKey) as? CIImage {
                let output = context.createCGImage(exposureOutput, from: exposureOutput.extent)
                let result = UIImage(cgImage: output!)
                imageView?.image = result
            }
        }
    }
}

