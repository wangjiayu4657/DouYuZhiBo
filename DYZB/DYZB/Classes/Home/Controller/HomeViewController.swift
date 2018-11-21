//
//  HomeViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/21.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - 懒加载
    private lazy var pageTitleView:PageTitleView = {
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: CGRect(x: 0, y: kNavgationBarH, width: kScreenW, height: 40), titles: titles)
        return titleView
    }()
    private lazy var pageContentView:PageContentView = {
        let contentViewY = kNavgationBarH + kTitleViewH
        let contentViewH = kScreenH - contentViewY
        var childVCs : [UIViewController] = [UIViewController]()
        for _ in 0..<4 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVCs.append(vc)
        }
        
       let contentView = PageContentView(frame: CGRect(x: 0, y: contentViewY, width: kScreenW, height: contentViewH), childVCs: childVCs, parentVC: self)
        contentView.backgroundColor = UIColor.red
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        //设置UI界面
        setupUI()
    }
}

// MARK: - 设置 UI 界面
extension HomeViewController {
    private func setupUI () {
        automaticallyAdjustsScrollViewInsets = false
        //设置导航按钮
        setupNavBarItem()
        
        //添加 pageTitleView
        view.addSubview(pageTitleView)
        
        //添加 pageContentView
        view.addSubview(pageContentView)
    }
    
    private func setupNavBarItem() {
        //设置leftBarItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        //设置rightBarItem
        let size = CGSize(width: 30, height: 30)
        let historyItem = UIBarButtonItem(imageName: "history", lightedName: "history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "search", lightedName: "search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "scan", lightedName: "scan_click", size: size)
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
}
