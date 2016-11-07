import UIKit
import AVFoundation

extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func presentCameraController() {
        let authorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if authorizationStatus == .authorized {
            callCameraPicker()
        } else if authorizationStatus == .denied {
            let url = URL(string: UIApplicationOpenSettingsURLString)
            
            let alert = UIAlertController(
                title: "Important",
                message: "Consultant Aide doesn't have permission to access your camera. If you want to take photos you need to allow camera access.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
                if let url = url {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }))
            present(alert, animated: true, completion: nil)
        } else {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: { (granted) in
                if granted {
                    self.callCameraPicker()
                } else {
                    self.animatePhotoSourceViewOut()
                }
            })
        }
    }
    
    @IBAction func presentPhotoLibraryController() {
        
    }
    
    @IBAction func unwindToNav(segue: UIStoryboardSegue) {
        print("Helloo")
    }
    
    @IBAction func setPrimaryPhoto() {
        captureIsForPrimaryImage = true
        animatePhotoSourceViewIn()
    }
    
    @IBAction func setSecondaryPhoto() {
        captureIsForPrimaryImage = false
        animatePhotoSourceViewIn()
    }
    
    @IBAction func animatePhotoSourceViewOut() {
        UIView.animate(withDuration: 0.1, animations: {
            self.photoSourceView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.photoSourceView.alpha = 0.0
            self.effectView.isHidden = true
        }, completion: { (success:Bool) in
            self.photoSourceView.removeFromSuperview()
        })
    }
    
    func callCameraPicker() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let picker = UIImagePickerController();
            picker.delegate = self
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        dismiss(animated: true, completion: {
            self.animatePhotoSourceViewOut()
            
            if self.captureIsForPrimaryImage {
                self.primaryImageView.image = image
                self.noImageMessage.isHidden = true
                self.saveButton.isHidden = false
//                self.defaultRatioButton.isHidden = false
//                self.squareRatioButton.isHidden = false
//                
//                if self.primaryImageView.image != nil {
//                    if let imageRatio = UserDefaults.standard.value(forKey: "defaultImageRatio") as? String {
//                        if imageRatio == "square" {
//                            self.setSquareRatio()
//                        } else {
//                            self.setDefaultRatio()
//                        }
//                    }
//                }
                
                self.showLabels()
            } else {
                let collageRect = CGRect(x: 0, y: 0, width: 125, height: 125)
                let collage = CollageImageView(frame: collageRect)
                collage.image = image
                collage.containWithin(view: self.containerView)
                
                self.containerView.addSubview(collage)
            }
        })
    }
    
    internal func animatePhotoSourceViewIn() {
        view.addSubview(photoSourceView)
        photoSourceView.center = view.center
        
        photoSourceView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        photoSourceView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.effectView.isHidden = false
            self.photoSourceView.alpha = 1
            self.photoSourceView.transform = CGAffineTransform.identity
        }
    }
}
