//
//  AnchorGroup.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/27.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class AnchorGroup: NSObject {
    
    @objc var tag_name : String = ""
    @objc var tag_id : String?
    @objc var room_list : [[String : Any]]? {
        didSet {
            guard let room_list = room_list else { return }
            for dict in room_list {
                self.anchors.append(AnchorModel(dict))
            }
        }
    }
    @objc var push_vertical_screen : Int = 0
    ///房间图标
    @objc var icon_name:String?
    @objc var icon_url:String = ""
    
    lazy var anchors:[AnchorModel] = [AnchorModel]()
    
    //构造函数
    override init() { }
    
    init(_ dict:[String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
