import UIKit
import AVFoundation

extension EditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func presentCameraController() {
        DispatchQueue.global(qos: .userInitiated).async {
            CameraAuthorization.GetAuthorizationStatus(completion: { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.callCameraPicker()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.animatePhotoSourceViewOut()
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
                        self.callPhotoPicker()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.animatePhotoSourceViewOut()
                        let encouragement = PhotosAuthorization.EncourageAccess()
                        self.present(encouragement, animated: true, completion: nil)
                    }
                }
            })
        }
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
            present(picker, animated: true, completion: nil)
        }
    }
    
    func callPhotoPicker() {
        let picker = UIImagePickerController();
        picker.delegate = self;
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        dismiss(animated: true, completion: {
            self.animatePhotoSourceViewOut()
            
            if self.captureIsForPrimaryImage {
                if let defaultScale = UserDefaults.standard.value(forKey: "defaultScrollViewScale") as? CGFloat {
                    self.scrollView.setZoomScale(defaultScale, animated: true)
                }
                
                self.primaryImageView.image = image
                self.noImageMessage.isHidden = true
                self.assistantToolbar.isHidden = false
                self.showLabels()
                self.toggleWatermarkVisibility()
                self.toggleWatermarkImageVisibility()
                self.toggleRatioButton.isHidden = false
                
                if let decider = UserDefaults.standard.value(forKey: "editorIsSquare") as? Bool {
                    if decider {
                        self.makeEditorSquare()
                    } else {
                        self.makeEditorRectangular()
                    }
                } else {
                    self.makeEditorSquare()
                }
            } else {
                self.setCollage(image: image)
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
