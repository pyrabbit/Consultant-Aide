import UIKit

extension EditorViewController:  UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return primaryImageView
    }
}
