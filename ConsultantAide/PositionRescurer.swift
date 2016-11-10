//
//  PositionRescurer
//  ConsultantAide
//
//  Created by Matthew Orahood on 11/9/16.
//  Copyright © 2016 Matthew Orahood. All rights reserved.
//

import Foundation
import UIKit

class PositionRescurer {
    static func rescue() {
        let point = CGPoint(x: 100, y: 100)
        
        UserDefaults.standard.set(point.x, forKey: "defaultLabelXPosition")
        UserDefaults.standard.set(point.y, forKey: "defaultLabelYPosition")
        UserDefaults.standard.set(point.y, forKey: "defaultWatermarkTextYCenter")
        UserDefaults.standard.set(point.x, forKey: "defaultWatermarkTextXCenter")
        UserDefaults.standard.set(point.y, forKey: "defaultWatermarkImageYCenter")
        UserDefaults.standard.set(point.x, forKey: "defaultWatermarkImageXCenter")
        UserDefaults.standard.set(point.x, forKey: "defaultCollageXPosition")
        UserDefaults.standard.set(point.y, forKey: "defaultCollageYPosition")
    }
}
