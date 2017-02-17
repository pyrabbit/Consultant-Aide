import UIKit
import Photos

extension LabelEditorViewController {
    
    @IBAction func savePhoto(sender: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async {
            PhotosAuthorization.GetAuthorizationStatus(completion: { granted in
                if granted {
                    DispatchQueue.main.async {
                        let image = self.convertPhoto()
                        self.saveToPhotosAlbum(image: image, completion: { success in
                            if (success) {
                                if let decider = UserDefaults.standard.value(forKey: "strAutoUploadIsEnabled") as? Bool {
                                    if (decider) {
                                        self.saveToShopTheRoe(image: image, completion: { success in
                                            if (success) {
                                                _ = self.navigationController?.popToRootViewController(animated: true)
                                            }
                                        })
                                    }
                                }
                                
                                _ = self.navigationController?.popToRootViewController(animated: true)
                            }
                        })

                    }
                } else {
                    DispatchQueue.main.async {
                        let encouragement = PhotosAuthorization.EncourageAccess()
                        self.present(encouragement, animated: true, completion: nil)
                    }
                }
            })
        }
//        
//        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveToPhotosAlbum(image: UIImage?, completion: @escaping (Bool)  -> ()) {
        guard let image = image else {
            return
        }
        
        let savingAlert = UIAlertController(title: "Saving to photo album...", message: "", preferredStyle: .alert)
        self.present(savingAlert, animated: true, completion: nil)
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        savingAlert.dismiss(animated: true, completion: {
            let savedAlert = UIAlertController(title: "Successfully saved in photo album!", message: "", preferredStyle: .alert)
            self.present(savedAlert, animated: true, completion: nil)
            
            let maxDisplayTime = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                savedAlert.dismiss(animated: true, completion: nil)
                completion(true)
            })
        })

    }
    
    func saveToShopTheRoe(image: UIImage?, completion: @escaping (Bool)  -> ()) {
        guard let image = image else {
            return
        }
        
        var activeAlert: UIAlertController!
        
        activeAlert = UIAlertController(title: "Uploading image to ShopTheRoe...", message: "", preferredStyle: .alert)
        self.present(activeAlert, animated: true, completion: nil)
        
        let service = STRService()
        service.createImage(image: image, completion: { success, id in
            if (success) {
                activeAlert.dismiss(animated: true, completion: {
                    activeAlert = UIAlertController(title: "Successfully uploaded image to ShopTheRoe!", message: "", preferredStyle: .alert)
                    self.present(activeAlert, animated: true, completion: nil)
                    
                    let maxDisplayTime = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                        activeAlert.dismiss(animated: true, completion: nil)
                        
                        if (self.labels.count >= 1) {
                            if let label = self.labels.first {
                                var optId: Int?
                                var optSizeId: Int?

                                optId = STRNormalizer.convert(styleId: label.styleId)
                                
                                if let size = label.sizes?.first {
                                    optSizeId = STRNormalizer.convert(size: size)
                                }
                                
                                if let styleId = optId, let sizeId = optSizeId {
                                    service.createItem(styleId: styleId, sizeId: sizeId, imageId: id, completion: { success, id in
                                        if (success) {
                                            activeAlert = UIAlertController(title: "Successfully created item on ShopTheRoe!", message: "", preferredStyle: .alert)
                                            self.present(activeAlert, animated: true, completion: nil)
                                            
                                            let maxDisplayTime = DispatchTime.now() + 1
                                            DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                                                activeAlert.dismiss(animated: true, completion: nil)
                                                completion(true)
                                            })
                                        } else {
                                            activeAlert = UIAlertController(title: "Failed to create item on ShopTheRoe", message: "", preferredStyle: .alert)
                                            self.present(activeAlert, animated: true, completion: nil)
                                            
                                            let maxDisplayTime = DispatchTime.now() + 1
                                            DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                                                activeAlert.dismiss(animated: true, completion: nil)
                                                completion(false)
                                            })
                                        }
                                    })
                                } else {
                                    activeAlert = UIAlertController(title: "Failed to create item on ShopTheRoe: Style or size not supported yet.", message: "", preferredStyle: .alert)
                                    self.present(activeAlert, animated: true, completion: nil)
                                    
                                    let maxDisplayTime = DispatchTime.now() + 1
                                    DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                                        activeAlert.dismiss(animated: true, completion: nil)
                                        completion(false)
                                    })
                                }
                            }
                        }
                        
                        completion(true)
                    })
                })
            } else {
                completion(false)
            }
        })
    }
    
    
    func convertPhoto() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            let scale = image.scale
            
            if let ciImageConversion = CIImage(image: image) {
                let context = CIContext(options: nil)
                
                if let newCGImage = context.createCGImage(ciImageConversion, from: ciImageConversion.extent) {
                    
                    let cropRect = CGRect(x: labelContainer.frame.origin.x * scale,
                                          y: labelContainer.frame.origin.y * scale + (20*scale),
                                          width: labelContainer.frame.width * scale,
                                          height: labelContainer.frame.height * scale)
                    
                    if let croppedImage = newCGImage.cropping(to: cropRect) {
                        UIGraphicsEndImageContext()
                        return UIImage(cgImage: croppedImage)
                    }
                }
            }
        }
        
        UIGraphicsEndImageContext()
        return nil
    }
}
