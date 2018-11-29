//
//  CycleModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/29.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class CycleModel: NSObject {
   @objc var title:String = ""
   @objc var pic_url:String = ""
   @objc var room:[String : Any]? {
        didSet {
            guard let room = room else { return }
            self.anchor = AnchorModel(room)
        }
    }
   var anchor:AnchorModel?
    
    init(_ dict:[String:Any]) {
        super.init()
        
        setValuesForKeys(dict);
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
