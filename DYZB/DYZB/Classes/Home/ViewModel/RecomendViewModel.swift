//
//  RecomendViewModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/27.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit


class RecomendViewModel : BaseViewModel {
    lazy var cycles:[CycleModel] = [CycleModel]()
    //推荐组
    private lazy var recomendGroup:AnchorGroup = AnchorGroup()
    //颜值组
    private lazy var prettyGroup:AnchorGroup = AnchorGroup()
}


// MARK: - 网络请求
extension RecomendViewModel {
    //请求推荐内容数据
    //http://capi.douyucdn.cn/api/v1/getHotCate?limit=4&offset=0&time=1474252024
    func requestData(finishedCallBack:@escaping ()->()) {
        let time = Date.currentTime()
        let param : [String : Any] = ["limit":4,"offset":0,"time":time]
        
        let group = DispatchGroup()
        
        group.enter()
        //请求第一部分推荐数据
        HttpClient.Request(type: .get, url: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", params: ["time":time]) { (response) in
            guard let dataDict = response as? [String : Any] else { return }
            guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
            
            self.recomendGroup.tag_name = "热门"
            self.recomendGroup.icon_name = "home_header_hot"
            
            for dict in dataArr {
                self.recomendGroup.anchors.append(AnchorModel(dict))
            }
            group.leave()
        }
        
        group.enter()
        //请求第二部分颜值数据
        HttpClient.Request(type: .get, url: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", params: param) { (response) in
            guard let dataDict = response as? [String : Any] else { return }
            guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
            
            self.prettyGroup.tag_name = "颜值"
            self.prettyGroup.icon_name = "home_header_phone"
            
            for dict in dataArr {
                self.prettyGroup.anchors.append(AnchorModel(dict))
            }
            
            group.leave()
        }
        
        group.enter()
        //请求2-12部分游戏数据
        anchorRequest(url: "http://capi.douyucdn.cn/api/v1/getHotCate",params: param) {
            group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.groups.insert(self.prettyGroup, at: 0)
            self.groups.insert(self.recomendGroup, at:0)
            
            finishedCallBack()
        }
    }
    
    //请求推荐界面轮播数据
    func requestCycleData(finishedCallBack:@escaping ()->()) {
        HttpClient.Request(type: .get, url: "http://www.douyutv.com/api/v1/slide/6", params: ["version":"2.300"]) { (response) in
            
            guard let dataDict = response as? [String : Any] else { return }
            guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
            for dict in dataArr {
                self.cycles.append(CycleModel(dict))
            }
            
            finishedCallBack()
        }
    }
}
