//
//  IntervalEnum.swift
//  MapConvertQuestion
//
//  Created by 丹羽遼吾 on 2020/03/03.
//  Copyright © 2020 ryogo.niwa. All rights reserved.
//

import Foundation
import UIKit

enum Interval:Int{
    case zero = 0
    case first = 1
    case second = 3
    case third = 7
    case fourth = 14
    case fifth = 30
    case sixth = 60
}


struct LetGroup {
    static let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
    static let todayEndMili = Calendar.current.startOfDay(for: tomorrow!).millisecondsSince1970 - 1
    static let tomorrowMili = tomorrow?.millisecondsSince1970
    static let todayStartMili = Calendar.current.startOfDay(for: Date()).millisecondsSince1970

}
