//
//  LabelEditorViewController+ImagePicker.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 1/7/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import UIKit

extension LabelEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            self.setCollage(image: image)
            self.collageSourceView.removeFromSuperview()
            self.modalBackground?.removeFromSuperview()
        })
    }
}
