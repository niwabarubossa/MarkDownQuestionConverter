//
//  OpinionFormButton.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

@IBDesignable class OpinionFormButton: UIView {
    
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
            //fontは定数で管理した方が良いのでは？　h1とかh2タグの名前で
            let font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight(300))
            titleLabel.font = font
        }
    }

}
