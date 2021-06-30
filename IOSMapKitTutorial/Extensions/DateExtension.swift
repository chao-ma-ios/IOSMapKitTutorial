//
//  DateExtension.swift
//  IOSMapKitTutorial
//
//  Created by Field Employee on 6/1/21.
//  Copyright © 2021 Arthur Knopper. All rights reserved.
//

import UIKit

//format date
extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
