//
//  STRNormalizer.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 2/13/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import Foundation

class STRNormalizer {
    static func convert(size: String) -> Int {
        switch size {
        case "XXS":
            return 1
        case "XS":
            return 2
        case "S":
            return 3
        case "M":
            return 4
        case "L":
            return 5
        case "XL":
            return 6
        case "2XL":
            return 7
        case "3XL":
            return 8
        case "TALL/CURVY":
            return 9
        case "KIDS S/M":
            return 11
        case "ONE SIZE":
            return 10
        case "KIDS L/XL":
            return 12
        case "1":
            return 43
        case "2":
            return 13
        case "3":
            return 44
        case "4":
            return 14
        case "6":
            return 15
        case "7":
            return 25
        case "8":
            return 16
        case "10":
            return 17
        case "11":
            return 26
        case "12":
            return 18
        case "14":
            return 19
        case "TWEEN":
            return 20
        case "3/4":
            return 21
        case "5/6":
            return 22
        case "8/10":
            return 23
        case "12/14":
            return 24
        default:
            return 0
        }
    }
    
    static func convert(styleId: String) -> Int {
        switch styleId {
        case "lularoe-adeline":
            return 44
        case "lularoe-amelia":
            return 8
        case "lularoe-ana":
            return 9
        case "lularoe-azure":
            return 4
        case "lularoe-bianka":
            return 42
        case "lularoe-carly":
            return 40
        case "lularoe-cassie":
            return 5
        case "lularoe-classic-t":
            return 19
        case "Dot Dot Smile Sleeve":
            return 26
        case "Dot Dot Smile Tank":
            return 25
        case "lularoe-gracie":
            return 34
        case "lularoe-irma":
            return 17
        case "lularoe-jade":
            return 15
        case "lularoe-jill":
            return 7
        case "lularoe-jordan":
            return 16
        case "lularoe-joy":
            return 39
        case "lularoe-julia":
            return 11
        case "lularoe-azure-kids":
            return 31
        case "lularoe-leggings-kids":
            return 30
        case "lularoe-lindsay":
            return 22
        case "lularoe-lola":
            return 6
        case "lularoe-lucy":
            return 2
        case "lularoe-madison":
            return 3
        case "lularoe-mae":
            return 43
        case "lularoe-mark":
            return 41
        case "lularoe-maxi":
            return 1
        case "lularoe-mimi":
            return 48
        case "lularoe-monroe":
            return 21
        case "lularoe-nicole":
            return 10
        case "lularoe-leggings":
            return 12
        case "lularoe-patrick":
            return 35
        case "lularoe-perfect-t":
            return 20
        case "lularoe-randy":
            return 18
        case "lularoe-sarah":
            return 23
        case "lularoe-sloan":
            return 27
        default:
            return 0
        }
    }
}
