//
//  QuestionAnswerTableViewCell.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/02/28.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class QuestionAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var nextDateLabel: UILabel!
    @IBOutlet weak var myImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
