import UIKit

extension UserDefaults {
    func stylesForKey(key: String) -> [Style: Set<String>]? {
        var styles: [Style: Set<String>]?
        if let styleData = data(forKey: key) {
            styles = NSKeyedUnarchiver.unarchiveObject(with: styleData) as? [Style: Set<String>]
        }
        return styles
    }
    
    func setStyles(styles: [Style: Set<String>]?, forKey key: String) {
        var styleData: NSData?
        if let styles = styles {
            styleData = NSKeyedArchiver.archivedData(withRootObject: styles) as NSData?
        }
        set(styleData, forKey: key)
    }
}
