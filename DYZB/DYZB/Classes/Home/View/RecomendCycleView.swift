//
//  RecomendCycleView.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/29.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

private let kCycleCellID = "kCycleCellID"

class RecomendCycleView: UIView {
    
    
    // MARK: - 控件属性
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - 定义属性
    private var timer:Timer?
    private var count:Int = 0
    
    
    // MARK: - 定义模型属性
    var cycleModels:[CycleModel]? {
        didSet {
            guard let count = cycleModels?.count else { return  }
            self.count = count * 10000
            collectionView.reloadData()
            pageControl.numberOfPages = cycleModels?.count ?? 0
            
            let indexPath = IndexPath(item: count * 100, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            //先移除定时器
            removeTimer()
            
            //开启定时器
            addTimer()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //设置该控件不随父控件的拉申而拉申
        autoresizingMask = UIView.AutoresizingMask()
        collectionView.register(UINib(nibName: "CollectionCycleCell", bundle: nil), forCellWithReuseIdentifier: kCycleCellID)
        
       
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }
}

// MARK: - 创建轮播图
extension RecomendCycleView {
    static func cycleView() -> RecomendCycleView {
        return Bundle.main.loadNibNamed("RecomendCycleView", owner: nil, options: nil)?.first as! RecomendCycleView
    }
}

// MARK: - 遵守UICollectionViewDataSource协议
extension RecomendCycleView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! CollectionCycleCell
        cell.anchor = cycleModels![indexPath.item % cycleModels!.count]
        return cell
    }
}

// MARK: - 遵守UICollectionViewDelegate协议
extension RecomendCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + collectionView.bounds.width * 0.5
        pageControl.currentPage = Int(offsetX / collectionView.bounds.width) % cycleModels!.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
}

extension RecomendCycleView {
    private func addTimer() {
        timer = Timer(timeInterval: 3.0, target: self, selector: #selector(scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    private func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    //滚动到下一张
    @objc func scrollToNext() {
        //当滑动一半时就改变 pagecontrol 的 currentPage
        let offsetX = collectionView.contentOffset.x
        let nextIndex = offsetX + collectionView.bounds.width
        
        collectionView.setContentOffset(CGPoint(x: nextIndex, y: 0), animated: true)
    }
}
