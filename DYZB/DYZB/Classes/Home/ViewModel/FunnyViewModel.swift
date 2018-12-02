//
//  FunnyViewModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/2.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class FunnyViewModel: BaseViewModel {

}


extension FunnyViewModel {
    func funnyRequest(finishedCallBack:@escaping ()->()) {

        //http://capi.douyucdn.cn/api/v1/getColumnRoom/3 ["limit":30,"offset":0]
        anchorRequest(isGroupData:true,url: "http://capi.douyucdn.cn/api/v1/getHotRoom/2", finishedCallBack: finishedCallBack)
    }
}
