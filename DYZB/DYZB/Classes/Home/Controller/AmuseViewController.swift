//
//  AmuseViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//  娱乐界面

import UIKit

private let kAmuseViewH:CGFloat = 200

class AmuseViewController: BaseAnchorViewController {

    // MARK: - 懒加载
    private lazy var amuseVM:AmuseViewModel = AmuseViewModel()
    private lazy var amuseView:AmuseMenuView = {
        let amuseView = AmuseMenuView.amuseView()
        amuseView.frame = CGRect(x: 0, y: -kAmuseViewH, width: kScreenW, height: kAmuseViewH)
        return amuseView
    }()
}

extension AmuseViewController {
    override func setupUI() {
        super.setupUI()
        sectionInsetTop = kAmuseViewH
        collectionView.addSubview(amuseView)
    }
}

// MARK: - 请求数据
extension AmuseViewController {
     override func requstData() {
        baseVM = amuseVM

        amuseVM.amuseRquest {
            self.collectionView.reloadData()
            
            var tempArr = self.amuseVM.groups
            tempArr.removeFirst()
            self.amuseView.amuseGroup = tempArr
            
            //数据请求完成时隐藏加载动画
            self.loadDataFinished()
        }
    }
}


