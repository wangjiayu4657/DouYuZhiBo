//
//  AnchorModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/27.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class AnchorModel: NSObject {
    ///房间 ID
    @objc var room_id:Int64 = 0
    ///房间图片对应的 URL
    @objc var vertical_src:String = ""
    ///0:电脑直播  1:手机直播
    @objc var isVertical:Int = 0
    ///房间名称
    @objc var room_name:String = ""
    ///主播昵称
    @objc var nickname:String = ""
    ///在线人数
    @objc var online:Int64 = 0
    ///游戏名称
    @objc var game_name:String = ""
    ///所在城市
    @objc var anchor_city:String = ""
    
    init(_ dict:[String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    
}
