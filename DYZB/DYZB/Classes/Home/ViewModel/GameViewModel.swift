//
//  GameViewModel.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class GameViewModel: NSObject {
    lazy var games:[GameModel] = [GameModel]()
}

extension GameViewModel {
    func gameRequest(finishedCallBack:@escaping ()->()) {
        HttpClient.Request(type: .get, url: "http://capi.douyucdn.cn/api/v1/getColumnDetail") { (response) in
            print(response)
            guard let dataDict = response as? [String : Any] else { return }
            guard let dataArr = dataDict["data"] as? [[String : Any]] else { return }
            
            for dict in dataArr {
                self.games.append(GameModel(dict))
            }
            
            finishedCallBack()
        }
    }
}
