//
//  SelectQustionPageThemeView.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/08.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class SelectQustionPageThemeView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        loadNib()
    }

    func loadNib() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
        self.titleLabel.text = "mapList".localized
    }

}
