//
//  TutorialContentModel.swift
//  cbt_diary
//
//  Created by 丹羽遼吾 on 2020/02/29.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import UIKit

struct TutorialContentModel{
    var title:String
    var content:String
    var imageIcon:UIImage?
    
    init(title:String,content:String,imageIcon:UIImage){
        self.title = title
        self.content = content
        self.imageIcon = imageIcon
    }
    
    static func createModels() -> [TutorialContentModel]{
        return [
            TutorialContentModel(title: "tutorialFirstTitle".localized, content: "tutorialFirstContent".localized, imageIcon: R.image.pencil()!),
            TutorialContentModel(title: "tutorialSecondTitle".localized, content: "tutorialSecondContent".localized, imageIcon: R.image.student()!),
            TutorialContentModel(title: "tutorialThirdTitle".localized, content: "tutorialThirdContent".localized, imageIcon: R.image.books()!)
        ]
    }
}
