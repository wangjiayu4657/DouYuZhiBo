//
//  AmuseViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//  娱乐界面

import UIKit

class AmuseViewController: BaseAnchorViewController {

    // MARK: - 懒加载
    private lazy var amuseVM:AmuseViewModel = AmuseViewModel()
}

// MARK: - 请求数据
extension AmuseViewController {
     override func requstData() {
        baseVM = amuseVM

        amuseVM.amuseRquest {
            self.collectionView.reloadData()
        }
    }
}


