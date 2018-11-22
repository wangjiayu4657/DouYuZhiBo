//
//  PageContentView.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/21.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

private let PageContentCellID = "PageContentCellID"

class PageContentView: UIView {

    // MARK: - 定义属性
    private let childVCs : [UIViewController]
    private weak var parentVC : UIViewController?
    
    // MARK: - 懒加载
    private lazy var collectionView:UICollectionView = { [weak self] in
        //创建布局样式 layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        //创建 collectionView
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.scrollsToTop = false;
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: PageContentCellID)
        collectionView.dataSource = self
        return collectionView
    }()
    
    
    // MARK: - 自定义构造函数
    init(frame: CGRect,childVCs:[UIViewController],parentVC:UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - 设置 UI 界面
extension PageContentView {
    private func setupUI() {
        //添加所有子控制器
        for vc in childVCs {
            parentVC?.addChild(vc)
        }
        
        //添加 collectionView
        addSubview(collectionView)
    }
}


// MARK: - 遵守 UICollectionViewDataSource
extension PageContentView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageContentCellID, for: indexPath)
        
         //考虑 cell 重复利用,所以先清除掉 contentView 中所有的子控件然后在添加
         for view in cell.contentView.subviews {
            view .removeFromSuperview()
         }
        
         let vc = childVCs[indexPath.item]
         vc.view.frame = cell.contentView.bounds
         cell.contentView.addSubview(vc.view)
         return cell
    }
}


// MARK: - 对外暴露的方法
extension PageContentView {
    func slideViewToSelectedView(offsetX:CGFloat) {
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
