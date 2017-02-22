import UIKit
import Photos
import GSMessages

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
                                        print("ShopTheRoe: Saving...")
                                        self.saveToShopTheRoe(image: image, completion: { success in
                                            if (success) {
                                                self.popToRootViewController(delay: 1.5)
                                            }
                                        })
                                    } else {
                                        self.popToRootViewController(delay: 1.5)
                                    }
                                } else {
                                    self.popToRootViewController(delay: 1.5)
                                }
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
    }
    
    func popToRootViewController(delay: TimeInterval) {
        let maxDisplayTime = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
            _ = self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func saveToPhotosAlbum(image: UIImage?, completion: @escaping (Bool)  -> ()) {
        guard let image = image else {
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        self.showMessage("Successfully saved in photo album!", type: .success)
        completion(true)
    }
    
    func saveToShopTheRoe(image: UIImage?, completion: @escaping (Bool)  -> ()) {
        guard let image = image else {
            return
        }
        
        let service = STRService()
        self.showMessage("Uploading image to ShopTheRoe...", type: .info, options: [
            .autoHide(false)
            ])
        
        service.createImage(image: image, completion: { success, id in
            if (success) {
                self.showMessage("Successfully uploaded image to ShopTheRoe!", type: .success)
                
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
                                    self.showMessage("Successfully uploaded item to ShopTheRoe!", type: .success)
                                } else {
                                    self.showMessage("Failed to upload item to ShopTheRoe!", type: .error)
                                }
                                
                                completion(true)
                            })
                        } else {
                            self.showMessage("Unsupported style or size.", type: .error)
                            completion(true)
                        }
                    }
                } else {
                    completion(true)
                }
                
            } else {
                self.showMessage("Failed to upload image to ShopTheRoe!", type: .error)
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
