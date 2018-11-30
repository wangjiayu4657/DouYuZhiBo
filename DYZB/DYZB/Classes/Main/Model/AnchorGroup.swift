//
//  AnchorGroup.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/27.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class AnchorGroup: BaseGameModel {
    @objc var tag_id : Int = 0
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
    
    lazy var anchors:[AnchorModel] = [AnchorModel]()
}
