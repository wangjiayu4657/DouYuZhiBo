//
//  PageCollectionView.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/6.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

protocol PageCollectionViewDataSource : class {
    //返回总共多少组
    func pageNumberOfSections(_ pageCollectionView:PageCollectionView) -> Int
    //返回每组有多少 items
    func pageCollectionView(_ pageCollectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int
    //返回 cell
    func pageCollectionView(_ pageCollectionView: PageCollectionView,collectionView:UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

class PageCollectionView: UIView {

    // MARK: - 定义属性
    weak var dataSource:PageCollectionViewDataSource?
    private var titles:[String]
    private var  style:JYPageStyle
    private var layout:AmuseMenuLayout
    
    // MARK: - 懒加载
    private lazy var collectionView:UICollectionView = { [unowned self] in
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: self.layout)
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.randomColor()
        return collectionView
    }()
    
    init(frame: CGRect,titles:[String],style:JYPageStyle,layout:AmuseMenuLayout) {
        self.titles = titles
        self.style = style
        self.layout = layout
        super.init(frame:frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置 UI
extension PageCollectionView {
    private func setupUI() {
        //titleView
        let titleViewY = style.isTitleInTop ? 0 : bounds.height - style.titleHeight - style.pageControlHeight
        let titleView = PageTitleView(frame: CGRect(x: 0, y: titleViewY, width: bounds.width, height: style.titleHeight), titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        addSubview(titleView)
        
        //collectionView
        let collectionViewY = style.isTitleInTop ? titleView.bounds.maxY : 0
        let collectionViewH = bounds.height - style.titleHeight - style.pageControlHeight
        collectionView.frame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: collectionViewH)
        addSubview(collectionView)
        
        //pageControl
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: bounds.height - style.pageControlHeight, width: bounds.width, height: style.pageControlHeight))
        pageControl.backgroundColor = UIColor.randomColor()
        pageControl.numberOfPages = 4
        pageControl.tintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        addSubview(pageControl)
    }
}

// MARK: - 对外暴露的方法
extension PageCollectionView {
    func pageRegister(cellClass:AnyClass?, forCellWithReuseIdentifier: String) {
         collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }

    func pageRegister(nib:UINib?, forCellWithReuseIdentifier: String) {
        collectionView.register(nib, forCellWithReuseIdentifier: forCellWithReuseIdentifier)
    }
    
    func pageReloadData() {
        collectionView.reloadData()
    }
}


// MARK: - 遵守UICollectionViewDataSource协议
extension PageCollectionView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.pageNumberOfSections(self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (dataSource?.pageCollectionView(self, collectionView: collectionView, cellForItemAt: indexPath))!
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
    
}
