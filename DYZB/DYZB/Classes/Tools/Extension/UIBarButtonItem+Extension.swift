//
//  UIBarButtonItem+Extension.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/21.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName:String,lightedName:String = "",size:CGSize = CGSize.zero){
        let historyBtn = UIButton()
        
        if size == CGSize.zero {
            historyBtn.sizeToFit()
        }else {
            historyBtn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        historyBtn.setImage(UIImage(named: imageName), for: .normal)
        if lightedName.count != 0 {
            historyBtn.setImage(UIImage(named: lightedName), for: .highlighted)
        }
        
        self.init(customView: historyBtn)
    }
}
