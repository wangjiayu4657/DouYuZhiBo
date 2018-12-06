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
    private lazy var currentIndexPath = IndexPath(item: 0, section: 0)
    
    // MARK: - 懒加载
    private lazy var titleView:PageTitleView = { [unowned self] in
        let titleViewY = style.isTitleInTop ? 0 : bounds.height - style.titleHeight - style.pageControlHeight
        let titleView = PageTitleView(frame: CGRect(x: 0, y: titleViewY, width: bounds.width, height: style.titleHeight), titles: titles, style: style)
        titleView.backgroundColor = UIColor.randomColor()
        titleView.delegate = self
        return titleView
    }()
    private lazy var collectionView:UICollectionView = { [unowned self] in
        let collectionViewY = style.isTitleInTop ? titleView.bounds.maxY : 0
        let collectionViewH = bounds.height - style.titleHeight - style.pageControlHeight
        let frame = CGRect(x: 0, y: collectionViewY, width: bounds.width, height: collectionViewH)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.randomColor()
        return collectionView
    }()
    private lazy var pageControl:UIPageControl = { [unowned self] in
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: bounds.height - style.pageControlHeight, width: bounds.width, height: style.pageControlHeight))
        pageControl.backgroundColor = UIColor.randomColor()
        pageControl.numberOfPages = 4
        pageControl.tintColor = UIColor.gray
        pageControl.currentPageIndicatorTintColor = UIColor.red
        return pageControl
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
        //添加titleView
        addSubview(titleView)
        
        //添加collectionView
        addSubview(collectionView)
        
        //添加pageControl
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
        let itemCount = dataSource?.pageCollectionView(self, numberOfItemsInSection: section) ?? 0
        //设置 pageControl的numberOfPages
        let count = (itemCount - 1) / (layout.rows * layout.cols) + 1
        if section == 0 {
            pageControl.numberOfPages = (itemCount - 1) / (layout.rows * layout.cols) + 1
        }
        return itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (dataSource?.pageCollectionView(self, collectionView: collectionView, cellForItemAt: indexPath))!
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}

// MARK: - 遵守UICollectionViewDelegate协议
extension PageCollectionView : UICollectionViewDelegate {
    //有减速的停止
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewEndScroll()
    }
    
    //没有减速的停止
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        scrollViewEndScroll()
    }
    
    func scrollViewEndScroll() {
        //一定能获取到 cell 的点
        let point = CGPoint(x:collectionView.contentOffset.x + layout.sectionInset.left + 1 , y: layout.sectionInset.top + 1)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        
        let items = dataSource?.pageCollectionView(self, numberOfItemsInSection: indexPath.section) ?? 0
        pageControl.numberOfPages = (items - 1) / (layout.cols * layout.rows) + 1
        
        //如果当前组不等于原来的组则滑动
        if indexPath.section != currentIndexPath.section {
             titleView.scrollToSelectedIndex(indexPath.section)
             currentIndexPath = indexPath
             pageControl.currentPage = 0
        }
        
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
    }
}

// MARK: - 遵守PageTitleViewDelegate协议
extension PageCollectionView : PageTitleViewDelegate {
    func titleView(_ titleView: PageTitleView, selectedIndex: Int) {
        let indexPath = IndexPath(item: 0, section: selectedIndex)
        //获取总组数
        let sections = dataSource?.pageNumberOfSections(self) ?? 0
        //获取总的 item 个数
        let items = dataSource?.pageCollectionView(self, numberOfItemsInSection: selectedIndex) ?? 0
        pageControl.numberOfPages = (items - 1) / (layout.rows * layout.cols) + 1
        pageControl.currentPage = 0
        //滚动到对应的位置
        collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
        //为了解决最后一组只有一页数据时左边间距偏大的问题
        if selectedIndex == (sections - 1) && items <= (layout.cols * layout.rows) { return }
        collectionView.contentOffset.x -= layout.sectionInset.left
        
        currentIndexPath = indexPath
    }
}
