import UIKit
import Photos

extension LabelEditorViewController {
    
    @IBAction func savePhoto(sender: UIButton) {
        DispatchQueue.global(qos: .userInitiated).async {
            PhotosAuthorization.GetAuthorizationStatus(completion: { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.convertAndSavePhoto()
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
    
    
    func convertAndSavePhoto() {
        UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            let scale = image.scale
            
            if let ciImageConversion = CIImage(image: image) {
                let context = CIContext(options: nil)
                
                if let newCGImage = context.createCGImage(ciImageConversion, from: ciImageConversion.extent) {
                    
                    let cropRect = CGRect(x: labelContainer.frame.origin.x * scale,
                                          y: labelContainer.frame.origin.y * scale,
                                          width: labelContainer.frame.width * scale,
                                          height: labelContainer.frame.height * scale)
                    
                    if let croppedImage = newCGImage.cropping(to: cropRect) {
                        let finalImage = UIImage(cgImage: croppedImage)
                        
                        let savingAlert = UIAlertController(title: "Saving...", message: "", preferredStyle: .alert)
                        self.present(savingAlert, animated: true, completion: nil)
                        
                        UIImageWriteToSavedPhotosAlbum(finalImage, nil, nil, nil)
                        
                        savingAlert.dismiss(animated: true, completion: {
                            let savedAlert = UIAlertController(title: "Saved!", message: "", preferredStyle: .alert)
                            self.present(savedAlert, animated: true, completion: nil)
                            
                            self.primaryImageView.image = nil
                            self.collage?.image = nil
                            self.collage?.isHidden = true
                            self.watermark?.isHidden = true
                            self.watermarkImage?.isHidden = true
                            
                            let maxDisplayTime = DispatchTime.now() + 1
                            DispatchQueue.main.asyncAfter(deadline: maxDisplayTime, execute: {
                                savedAlert.dismiss(animated: true, completion: nil)
                            })
                        })
                        

                    }
                }
            }
        }
        
        UIGraphicsEndImageContext()
    }
}
