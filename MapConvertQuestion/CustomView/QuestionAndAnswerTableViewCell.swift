//
//  QuestionAndAnswerTableViewCell.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/27.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class QuestionAndAnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setUpCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setUpCell()
        // Configure the view for the selected state
    }
    
    private func setUpCell(){
        
    }

}
