//
//  IntExtension.swift
//  Hexaware
//
//  Created by Vinod Reddy Sure on 07/01/21.
//  Copyright © 2021 Vinod Reddy Sure. All rights reserved.
//

import UIKit

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}
