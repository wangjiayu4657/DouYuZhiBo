//
//  AmuseViewModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class AmuseViewModel {
    lazy var amuses:[AnchorGroup] = [AnchorGroup]()
}

extension AmuseViewModel {
    func amuseRquest(finishedCallBack:@escaping()->()) {
        HttpClient.Request(type: .get, url: "http://capi.douyucdn.cn/api/v1/getHotRoom/2") { (response) in
            guard let dataDict = response as? [String : Any] else { return }
            guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
            
            for dict in dataArr {
                self.amuses.append(AnchorGroup(dict))
            }
            
            finishedCallBack()
        }
    }
}
