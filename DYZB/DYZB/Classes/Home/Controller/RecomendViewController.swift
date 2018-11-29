//
//  RecomendViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/23.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit


// MARK: - 定义常量
private let kItemMargin:CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3
private let kCycleViewH:CGFloat = 150

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kCellHeaderViewID = "kCellHeaderViewID"

class RecomendViewController: UIViewController {

    // MARK: - 懒加载
    private lazy var recomendVM:RecomendViewModel = RecomendViewModel()
    //轮播图
    private lazy var cycleView:RecomendCycleView = {
       let cycleView = RecomendCycleView.cycleView()
        cycleView.frame = CGRect(x: 0, y: -kCycleViewH, width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    private lazy var collectionView:UICollectionView = {
        //创建 collectionView 的布局样式
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        //设置item 之间的列间距
        layout.minimumInteritemSpacing = kItemMargin
        //设置组头的size
        layout.headerReferenceSize = CGSize(width: kScreenW, height: 50)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderViewID)
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        //请求数据
        loadCycleData()
        loadCommendContentData()
    }

}

// MARK: -  设置 UI 界面
extension RecomendViewController {
    private func setupUI() {
        //添加轮播图
        collectionView.addSubview(cycleView)
        //添加 collectionView
        view.addSubview(collectionView)
    }
}

// MARK: - 数据请求
extension RecomendViewController {
    
    //请求轮播图数据
    func loadCycleData() {
        recomendVM.requestCycleData {
            self.cycleView.cycleModels = self.recomendVM.cycles
        }
    }
    
    //请求推荐内容数据
    func loadCommendContentData() {
        recomendVM.requestData {[weak self] in
            self?.collectionView.reloadData()
        }
    }
    
}

// MARK: - 遵守UICollectionViewDataSource协议
extension RecomendViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return recomendVM.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let group = recomendVM.groups[section]
        return group.anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kItemW, height: kNormalItemH)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionBaseCell
        
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
        }else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        }
        
        let anchorGroup = recomendVM.groups[indexPath.section];
        cell.anchor = anchorGroup.anchors[indexPath.item]
        
        return cell
    }
}

// MARK: - 遵守UICollectionViewDelegate协议
extension RecomendViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kCellHeaderViewID, for: indexPath) as! CollectionHeaderView

        sectionHeaderView.groupModel = recomendVM.groups[indexPath.section]
        
        return sectionHeaderView
    }
}

