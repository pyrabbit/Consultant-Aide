//
//  SettingsViewController+ImagePicker.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/9/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import AVFoundation
import UIKit

extension SettingsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func presentPhotoLibraryController() {
        DispatchQueue.global(qos: .userInitiated).async {
            PhotosAuthorization.GetAuthorizationStatus(completion: { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.callPhotoPicker()
                    }
                } else {
                    DispatchQueue.main.async {
                        let encouragement = PhotosAuthorization.EncourageAccess()
                        self.present(encouragement, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func callPhotoPicker() {
        let picker = UIImagePickerController();
        picker.delegate = self;
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func showImageTooLargeAlert() {

    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("Could not set image to UIImage")
            return
        }
        
        guard image.size.width <= 128.0 || image.size.height <= 128.0 else {
            print("Watermark image is too big.")
            let alert = UIAlertController(title: "Image too large", message: "The image cannot have a height or width larger than 128px. That may seem small but it takes up quite a bit of space on the screen.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            picker.present(alert, animated: true, completion: nil)
            return
        }
        
        dismiss(animated: true, completion: {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentsURL.appendingPathComponent("watermark.png")
            let data = UIImagePNGRepresentation(image)
            
            do {
                try data?.write(to: fileURL, options: .atomic)
                self.watermarkImage.image = image
            } catch {
                print("Could not save watermark image.")
                self.watermarkImage.image = nil
            }

        })
    }
}
