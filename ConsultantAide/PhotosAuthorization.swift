//
//  PhotosAuthorization.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/7/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Photos
import UIKit

class PhotosAuthorization {

    static func GetAuthorizationStatus(completion: @escaping (_ granted: Bool) -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            completion(true)
        case .denied, .restricted:
            completion(false)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    completion(true)
                case .denied, .restricted:
                    completion(false)
                default:
                    completion(false)
                }
            }
        }
    }
    
    static func EncourageAccess() -> UIAlertController {
        let url = URL(string: UIApplicationOpenSettingsURLString)
        
        let alert = UIAlertController(
            title: "Important",
            message: "Consultant Aide doesn't have permission to access your photo library. If you want to save or import photos you need to allow Photos access.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (alert) -> Void in
            if let url = url {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        
        return alert
    }
    
}
