//
//  SimpleTableViewCell.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/26.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class SimpleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setUpCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.setUpCell()
    }
    
    private func setUpCell(){
        self.titleLabel.font = UIFont(name: LetGroup.baseFontName, size: 20)
    }
}
