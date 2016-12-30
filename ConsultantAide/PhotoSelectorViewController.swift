//
//  PhotoSelectorViewController.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 12/10/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import UIKit
import AVFoundation

class PhotoSelectorViewController: UIViewController {
    var selectedImage: UIImage?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        let vc = segue.destination as! PhotoEditorViewController
        vc.selectedImage = selectedImage
    }
    
    @IBAction func openFacebookGroup(_ sender: Any) {
        if let url = URL(string: "fb://group?id=898845000237494") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func presentCameraController() {
        DispatchQueue.global(qos: .userInitiated).async {
            CameraAuthorization.GetAuthorizationStatus(completion: { granted in
                if granted {
                    DispatchQueue.main.async {
                        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                            let picker = UIImagePickerController();
                            picker.delegate = self
                            picker.sourceType = .camera
                            self.present(picker, animated: true, completion: nil)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let encouragement = CameraAuthorization.EncourageAccess()
                        self.present(encouragement, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    @IBAction func presentPhotoLibraryController() {
        DispatchQueue.global(qos: .userInitiated).async {
            PhotosAuthorization.GetAuthorizationStatus(completion: { granted in
                if granted {
                    DispatchQueue.main.async {
                        let picker = UIImagePickerController();
                        picker.delegate = self
                        picker.sourceType = .photoLibrary
                        self.present(picker, animated: true, completion: nil)
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
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        dismiss(animated: true, completion: {
            self.selectedImage = image
            self.performSegue(withIdentifier: "segueToPhotoEditor", sender: nil)
        })
    }
}
