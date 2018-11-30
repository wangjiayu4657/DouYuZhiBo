//
//  BaseGameModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class BaseGameModel: NSObject {
    @objc var tag_name:String = ""
    @objc var icon_url:String = ""
    
    init(_ dict:[String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    //构造函数
    override init() { }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
