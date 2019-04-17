//
//  GameViewModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

//方式一:通过网络工具类进行网络请求
class GameViewModel: NSObject {
    lazy var games:[GameModel] = [GameModel]()
}

extension GameViewModel {
    func gameRequest(finishedCallBack:@escaping ()->()) {
        HttpClient.Request(type: .get, url: "http://capi.douyucdn.cn/api/v1/getColumnDetail") { (response) in   
            guard let dataDict = response as? [String : Any] else { return }
            guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
            
            for dict in dataArr {
                self.games.append(GameModel(dict))
            }
            
            finishedCallBack()
        }
    }
}

//方式二:利用面向协议进行网络请求
//class GameViewModel: NSObject,Httpable {
      //重写协议中定义的属性即为协议中的属性赋值
//    var url: String = "http://capi.douyucdn.cn/api/v1/getColumnDetail"
//    var type: MethodType = .get
//    var params:[String : Any] = [String:Any]()
//    typealias resultType = [GameModel]
//    var results: [GameModel] = [GameModel]()
//}


//extension GameViewModel {
      //协议中的解析方法
//    func parseResult(_ result: Any) {
//        guard let dataDict = result as? [String : Any] else { return }
//        guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
//
//        for dict in dataArr {
//            self.results.append(GameModel(dict))
//        }
//    }
//}
