//
//  HttpClient.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/27.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit
import Alamofire

enum methodType {
    case get
    case post
}

class HttpClient {
    class func Request(type:methodType,url:String,params:[String:Any]?=nil,callBack:@escaping (_ response:Any)->()) {
        
        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
        Alamofire.request(url, method: method, parameters: params).responseJSON { (response) in
            guard let result = response.result.value else {
                print(response.result.error ?? "请求失败")
                return
            }
            
            callBack(result)
        }
       
    }
}
