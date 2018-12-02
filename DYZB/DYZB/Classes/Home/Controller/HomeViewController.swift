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
        titleView.delegate = self
        return titleView
    }()
    private lazy var pageContentView:PageContentView = { [weak self] in 
        let contentViewY = kNavgationBarH + kTitleViewH
        let contentViewH = kScreenH - contentViewY
        var childVCs : [UIViewController] = [UIViewController]()
        childVCs.append(RecomendViewController())
        childVCs.append(GameViewController())
        childVCs.append(AmuseViewController())
        childVCs.append(FunnyViewController())
        
       let contentView = PageContentView(frame: CGRect(x: 0, y: contentViewY, width: kScreenW, height: contentViewH), childVCs: childVCs, parentVC: self)
        contentView.backgroundColor = UIColor.red
        contentView.delegate = self
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

// MARK: - 遵守PageTitleViewDelegate协议
extension HomeViewController : PageTitleViewDelegate {
    func titleView(_ titleView: PageTitleView, selectedIndex : Int) {
        let offsetX = CGFloat(selectedIndex) * kScreenW
        pageContentView.slideViewToSelectedView(offsetX: offsetX)
    }
}

// MARK: - 遵守PageContentViewDelegate协议
extension HomeViewController : PageContentViewDelegate {
    func contentView(_ contentView: PageContentView, radio: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.selectedTitleLabeWith(radio: radio, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
