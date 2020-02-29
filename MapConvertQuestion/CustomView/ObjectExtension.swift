//
//  Extension.swift
//  cbt_diary
//
//  Created by 丹羽遼吾 on 2020/02/10.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    @nonobjc class var className: String {
        return String(describing: self)
    }

    @nonobjc var className: String {
        return type(of: self).className
    }
}
extension UITableViewCell {
    // Xibファイルを生成して返します。
    class func createXib() -> UINib {
        return UINib.init(nibName: self.className, bundle: nil)
    }
    func createXib() -> UINib {
        return UINib.init(nibName: self.className, bundle: nil)
    }
}

extension UICollectionViewCell {
    // Xibファイルを生成して返します。
    class func createXib() -> UINib {
        return UINib.init(nibName: self.className, bundle: nil)
    }
    func createXib() -> UINib {
        return UINib.init(nibName: self.className, bundle: nil)
    }
}
