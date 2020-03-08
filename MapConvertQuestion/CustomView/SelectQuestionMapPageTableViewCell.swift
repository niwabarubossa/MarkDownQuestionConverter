//
//  SelectQuestionMapPageTableViewCell.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/01.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class SelectQuestionMapPageTableViewCell: UITableViewCell {

    @IBOutlet weak var mapTitleLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func layout(){
        mapTitleLabel.numberOfLines = 0
        let font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight(300))
        mapTitleLabel.font = font
//        mapTitleLabel.textColor =
    }
    
}
