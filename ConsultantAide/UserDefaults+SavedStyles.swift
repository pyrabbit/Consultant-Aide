import UIKit

extension UserDefaults {
    
    func stylesForKey(key: String) -> [String:Set<String>]? {
        var styles: [String:Set<String>]?
        if let styleData = data(forKey: key) {
            styles = NSKeyedUnarchiver.unarchiveObject(with: styleData) as? [String:Set<String>]
        }
        return styles
    }
    
    func setStyles(styles: [String:Set<String>]?, forKey key: String) {
        var styleData: NSData?
        if let styles = styles {
            styleData = NSKeyedArchiver.archivedData(withRootObject: styles) as NSData?
        }
        set(styleData, forKey: key)
    }
}
