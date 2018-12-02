//
//  BaseViewModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/1.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class BaseViewModel {
    lazy var groups:[AnchorGroup] = [AnchorGroup]()
}

extension BaseViewModel {
    func anchorRequest(isGroupData:Bool,url:String,params:[String:Any]? = nil,finishedCallBack:@escaping ()->()) {
        HttpClient.Request(type: .get, url: url,params: params) { (response) in
            guard let dataDict = response as? [String : Any] else { return }
            guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
            
            if isGroupData {  //如果是分组数据的话就转成AnchorGroup模型
                for dict in dataArr {
                    self.groups.append(AnchorGroup(dict))
                }
            } else {         //如果不是分组数据的话就转成AnchorModel模型
                print(response)
                let anchorGroup = AnchorGroup()
                
                for dict in dataArr {
                    anchorGroup.anchors.append(AnchorModel(dict))
                }
                self.groups.append(anchorGroup)
            }
            
            finishedCallBack()
        }
    }
}
