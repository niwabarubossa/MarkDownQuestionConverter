//
//  MyColor.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/08.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import UIKit

class MyColor : UIColor {
    //hexは大文字小文字どちらでもおk
    class var base: UIColor {
        return UIColor(hex: "#e7ebe3")
    }
    class var main:UIColor {
      return UIColor(hex: "#C0C0C0")
    }
    class var accent:UIColor {
      return UIColor(hex: "#3c5af0")
    }
    class var textGrayColor:UIColor{
        return UIColor(hex: "#808080")
    }
    class var textBlueColor:UIColor{
        return UIColor(hex: "#0066CC")
    }
}

extension UIColor {
    convenience init(hex: String) {
        // スペースや改行がはいっていたらトリムする
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        // 頭に#がついていたら取り除く
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        // RGBに変換する
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
