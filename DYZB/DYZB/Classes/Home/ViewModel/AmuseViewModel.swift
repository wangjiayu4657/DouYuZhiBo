//
//  AmuseViewModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class AmuseViewModel : BaseViewModel {
    
}

extension AmuseViewModel {
    func amuseRquest(finishedCallBack:@escaping()->()) {
        anchorRequest(isGroupData:true,url: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishedCallBack: finishedCallBack)
    }
}
