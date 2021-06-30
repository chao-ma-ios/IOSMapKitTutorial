//
//  FormatTempFloatExtension.swift
//  IOSMapKitTutorial
//
//  Created by Field Employee on 6/1/21.
//  Copyright © 2021 Arthur Knopper. All rights reserved.
//

import Foundation
import UIKit
extension Float {
    func truncate(places : Int)-> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
    
    func formatWind() -> Float {
        let windValue = self
        return windValue.truncate(places: 1)
    }
    
    func formatTemp() -> Int {
        let tempValue = self
        return Int(tempValue)
    }
}
