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
    func anchorRequest(url:String,params:[String:Any]? = nil,finishedCallBack:@escaping ()->()) {
        HttpClient.Request(type: .get, url: url,params: params) { (response) in
            guard let dataDict = response as? [String : Any] else { return }
            guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
            
            for dict in dataArr {
                self.groups.append(AnchorGroup(dict))
            }
            
            finishedCallBack()
        }
    }
}
