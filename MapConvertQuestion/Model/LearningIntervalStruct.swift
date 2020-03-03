//
//  LearningIntervalStruct.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/03.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation

struct LearningIntervalStruct{
    var ifSuccessNextInterval:Int
    var nextLearningDate:Int64
    init(ifSuccessNextInterval:Int,nextLearningDate:Int64){
        self.ifSuccessNextInterval = ifSuccessNextInterval
        self.nextLearningDate = nextLearningDate
    }
}
