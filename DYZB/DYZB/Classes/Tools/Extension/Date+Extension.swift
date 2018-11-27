//
//  Date+Extension.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/27.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import Foundation

extension Date {
    static func currentTime() ->String {
        let date = Date()
        let timeInterval = UInt64(date.timeIntervalSince1970)
        return "\(timeInterval)"
    }
}
