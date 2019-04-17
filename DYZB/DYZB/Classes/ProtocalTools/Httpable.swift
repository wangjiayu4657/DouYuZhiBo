//
//  Httpable.swift
//  DYZB
//
//  Created by wangjiayu on 2019/4/17.
//  Copyright © 2019 wangjiayu. All rights reserved.
//  面向协议进行网络请求

import UIKit
import Alamofire

enum MethodType {
    case get
    case post
}

protocol Httpable {
    var url:String { get }
    var type:MethodType { get }
    var params:Parameters { get }
    
    //关联类型
    associatedtype resultType
    var results:resultType { get }
    
    //解析结果
    func parseResult(_ result:Any)
}


extension Httpable {
    func request(_ callBack:@escaping()->Void) {
        let method = type == MethodType.get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(url, method: method, parameters: params).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error ?? "请求失败")
                return
            }
            
            self.parseResult(result)
            callBack()
        }
    }
}

