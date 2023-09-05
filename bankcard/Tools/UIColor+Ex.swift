//
//  UIColor+Ex.swift
//  bankcard
//
//  Created by rosua le on 2023/8/30.
//

import UIKit

extension UIColor {
   static func hexColor(hex:String)->UIColor {
        return hexStringToUIColor(hex: hex)
    }
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

func getLineGradintLayer(ui:UIView, fromHexColor:String ,toHexColor:String) -> CAGradientLayer {
    let layerGradient = CAGradientLayer()
    layerGradient.colors = [hexStringToUIColor(hex:fromHexColor).cgColor,  hexStringToUIColor(hex: toHexColor).cgColor]
    layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
    layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
    layerGradient.frame = CGRect(x: 0, y: 0, width: ui.bounds.width, height: ui.bounds.height)
    return layerGradient
}
