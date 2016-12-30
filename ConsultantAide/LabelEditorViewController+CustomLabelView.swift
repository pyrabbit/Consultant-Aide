
import UIKit

extension LabelEditorViewController: UITextFieldDelegate {
    
    @IBAction func cancel() {
        animateCustomLabelViewOut()
    }
    
    @IBAction func finishedWithCustomLabel() {
        guard let customLabel = customStyleView else {
            return
        }
        
        labels.append(customLabel)
        customLabel.containWithin(view: containerView)
        containerView.addSubview(customLabel)
        
        let savedObject = saveCustomLabel(style: customLabel.style, price: customLabel.price, sizes: customLabel.sizes)

        animateCustomLabelViewOut()
    }
    
    @IBAction func changeStyle() {
        guard let style = styleField.text, style.characters.count > 0 else {
            customLabelViewFinishButton.isHidden = true
            return
        }
        
        var price: Float = 0.0
        
        if let text = priceField.text {
            if text.isEmpty {
                price = 0.0
            } else {
                if let value = Float(text) {
                    price = value
                }
            }
        }
        
        var sizes: [String]?
        
        if let text = sizeField.text {
            if text.isEmpty {
                sizes = nil
            } else {
                sizes = [text]
            }
        }
        
        customStyleView = StyleView(style: style, price: price, sizes: sizes)
        customLabelViewFinishButton.isHidden = false
    }
    
    @IBAction func animateCustomLabelViewIn() {
        view.bringSubview(toFront: effectView)
        view.addSubview(customStyleLabelView)
        customStyleLabelView.center = view.center
        
        customStyleLabelView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        customStyleLabelView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.effectView.isHidden = false
            self.customStyleLabelView.alpha = 1
        }
    }
    
    internal func animateCustomLabelViewOut() {
        UIView.animate(withDuration: 0.1, animations: {
            self.customStyleLabelView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.customStyleLabelView.alpha = 0.0
            self.effectView.isHidden = true
        }, completion: { (success:Bool) in
            self.customStyleLabelView.removeFromSuperview()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        styleField.resignFirstResponder()
        priceField.resignFirstResponder()
        sizeField.resignFirstResponder()
        return true
    }
    
    func saveCustomLabel(style: String, price: Float, sizes: [String]?) -> SavedLabel {
        let savedLabel = SavedLabel(context: context)
        savedLabel.brand = "Custom"
        savedLabel.name = style
        savedLabel.price = price
        savedLabel.sizes = sizes
        ad.saveContext()
        return savedLabel
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
