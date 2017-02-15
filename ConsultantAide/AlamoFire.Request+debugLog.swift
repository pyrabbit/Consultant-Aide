//
//  AlamoFire.Request+debugLog.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 2/15/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import Foundation
import Alamofire

extension Alamofire.Request {
    public func debugLog() -> Self {
        #if DEBUG
            debugPrint(self)
        #endif
        return self
    }
}
