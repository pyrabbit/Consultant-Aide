import UIKit
import Photos

extension LabelEditorViewController {
    
    @IBAction func savePhoto(sender: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async {
            PhotosAuthorization.GetAuthorizationStatus(completion: { granted in
                if granted {
                    DispatchQueue.main.async {
                        let image = self.covertPhoto()
                        self.saveToPhotosAlbum(image: image)
                        
                        if (true) {
                            let service = STRService()
                            service.createImage(image: image, completion: { success, id in
                                if (success) {
                                    if (self.labels.count >= 1) {
                                        if let label = self.labels.first {
                                            var optId: Int?
                                            var optSizeId: Int?
                                            
                                            optId = STRNormalizer.convert(styleId: label.styleId)
                                            
                                            if let size = label.sizes?.first {
                                                optSizeId = STRNormalizer.convert(size: size)
                                            }
                                        
                                            if let styleId = optId, let sizeId = optSizeId {
                                                print("Uploading new item to STR")
                                                service.createItem(styleId: styleId, sizeId: sizeId, imageId: id)
                                            }
                                        }
                                    }

                                }
                            })
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        let encouragement = PhotosAuthorization.EncourageAccess()
                        self.present(encouragement, animated: true, completion: nil)
                    }
                }
            })
        }
        
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func saveToPhotosAlbum(image: UIImage?) {
        guard let image = image else {
            return
        }
        
        let savingAlert = UIAlertController(title: "Saving...", message: "", preferredStyle: .alert)
        self.present(savingAlert, animated: true, completion: nil)
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        savingAlert.dismiss(animated: true, completion: {
            let savedAlert = UIAlertController(title: "Saved!", message: "", preferredStyle: .alert)
            self.present(savedAlert, animated: true, completion: nil)
            
            let maxDisplayTime = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                savedAlert.dismiss(animated: true, completion: nil)
            })
        })

    }
    
    
    func covertPhoto() -> UIImage? {
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
