//
//  Colors.swift
//  Dopplerr
//
//  Created by Eric Castillo on 12/27/18.
//  Copyright © 2018 Eric Castillo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    struct Theme {
        static var clear: UIColor { return UIColor.clear }
        static var white: UIColor { return UIColor.white }
        static var black: UIColor { return UIColor.black }
        static var lightGray: UIColor { return UIColor(named: "Light Gray")! }
        static var mediumGray: UIColor { return UIColor(named: "Medium Gray")! }
        static var darkGray: UIColor { return UIColor(red: 118/255, green: 118/255, blue: 118/255, alpha: 1) }
        static var lightBlue: UIColor { return UIColor(red: 48/255, green: 186/255, blue: 241/255, alpha: 1) }
        
        static var primary: UIColor { return UIColor(named: "Primary")! }
        
        static var success: UIColor { return UIColor(named: "Success")! }
        static var warning: UIColor { return UIColor(named: "Warning")! }
        static var error: UIColor { return UIColor(named: "Error")! }
    }
}


//extension UIColor {
//    var hexString: String {
//        let colorRef = cgColor.components
//        let r = colorRef?[0] ?? 0
//        let g = colorRef?[1] ?? 0
//        let b = ((colorRef?.count ?? 0) > 2 ? colorRef?[2] : g) ?? 0
//        let a = cgColor.alpha
//
//        var color = String(
//            format: "#%02lX%02lX%02lX",
//            lroundf(Float(r * 255)),
//            lroundf(Float(g * 255)),
//            lroundf(Float(b * 255))
//        )
//
//        if a < 1 {
//            color += String(format: "%02lX", lroundf(Float(a)))
//        }
//
//        return color
//    }
//}
