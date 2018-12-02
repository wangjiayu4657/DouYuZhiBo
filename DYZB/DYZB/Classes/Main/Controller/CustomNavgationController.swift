//
//  CustomNavgationController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/2.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class CustomNavgationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - 添加全屏pop手势
        //获取系统的 pop 手势
        guard let popGes = interactivePopGestureRecognizer else { return }
        //获取添加 pop 手势的 view
        guard let gesView = popGes.view else { return }
        
//        通过运行时查看UIGestureRecognizer中所有属性
//        var count:UInt32 = 0
//        guard let Ivars = class_copyIvarList(UIGestureRecognizer.self, &count) else { return }
//        print("===========")
//        for i in 0..<count {
//            let ivar = Ivars[Int(i)]
//            let name = ivar_getName(ivar)
//            let temp = String(cString: name!)
//            print(temp)
//        }
//
        //获取_targets对应是数组
        guard let targets = popGes.value(forKey: "_targets") as? [AnyObject] else { return }
        //获取 popGes 手势中的 target
        guard let target = targets.first?.value(forKey: "target") else { return }
        //创建 popGes 手势中执行的 Selector
        let action = Selector(("handleNavigationTransition:"))
        //创建自己的手势
        let gesPan = UIPanGestureRecognizer(target: target, action: action)
        //将手势添加到系统原来添加 pop 手势的视图上
        gesView.addGestureRecognizer(gesPan)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.hidesBottomBarWhenPushed = true
        super.pushViewController(viewController, animated: animated)
    }
}
