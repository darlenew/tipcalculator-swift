//
//  Utilities.swift
//  tipcalculator-swift
//
//  Created by Darlene Wong on 8/30/15.
//  Copyright (c) 2015 Darlene Wong. All rights reserved.
//

import Foundation
import UIKit

func updateTheme(vc: UIViewController, theme: String) {
    var background: UIColor
    var foreground: UIColor
    println("updating theme to %s", theme)
    switch theme {
        case "oak":
            background = UIColor.yellowColor()
            foreground = UIColor.greenColor()
        case "sfo":
            background = UIColor.blackColor()
            foreground = UIColor.orangeColor()
        default:
            background = UIColor.whiteColor()
            foreground = UIColor.blackColor()
    }
    println("updateTheme: %s", theme)
//    UIView.appearance().tintColor = background
    UITextField.appearance().textColor = foreground
    UITextField.appearance().layer.borderColor = foreground.CGColor
    UILabel.appearance().textColor = foreground

    UIButton.appearance().titleLabel?.textColor = foreground
    UIButton.appearance().setTitleColor(foreground, forState: .Normal)
    UIButton.appearance().layer.borderWidth = 2.0
    UIButton.appearance().layer.borderColor = foreground.CGColor

    UIStepper.appearance().tintColor = foreground    
    vc.view.tintColor = background
    vc.view.backgroundColor = background
    vc.view.layer.borderColor = foreground.CGColor

}

func updateDefaultTheme(vc: UIViewController) {
    // Update to the theme set in NSUserDefaults, use the oak theme if not set.
    var defaults = NSUserDefaults.standardUserDefaults()
    if let defaultTheme = defaults.stringForKey("defaultTheme") {
        updateTheme(vc, defaultTheme)
    } else {
        updateTheme(vc, "oak")
    }
}