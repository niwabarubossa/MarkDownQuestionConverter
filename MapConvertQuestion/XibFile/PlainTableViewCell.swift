//
//  PlainTableViewCell.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/04/26.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import UIKit

class PlainTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    var contentLabelText:String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        setupCell()
    }
    
    private func setupCell(){
        self.contentLabel.text = self.contentLabelText
    }

}
