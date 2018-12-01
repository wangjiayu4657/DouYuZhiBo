//
//  AmuseViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

// MARK: - 定义常量
private let kItemMargin:CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH = kItemW * 3 / 4
private let kPrettyItemH = kItemW * 4 / 3
private let kCycleViewH:CGFloat = kScreenW * 3 / 8
private let kGameViewH:CGFloat = 90


private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kCellHeaderViewID = "kCellHeaderViewID"

class AmuseViewController: UIViewController {

    // MARK: - 懒加载
    private lazy var amuseVM:AmuseViewModel = AmuseViewModel()
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
//        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
//        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        requstData()
    }
}

// MARK: - 设置 UI
extension AmuseViewController {
    private func  setupUI() {
        view.addSubview(collectionView)
    }
}

// MARK: - 请求数据
extension AmuseViewController {
    private func requstData() {
        amuseVM.amuseRquest {
         self.collectionView.reloadData()
        }
    }
}

// MARK: - 遵守UICollectionViewDataSource协议
extension AmuseViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
         return amuseVM.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return amuseVM.groups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        
        cell.anchor = amuseVM.groups[indexPath.section].anchors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kCellHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.groupModel = amuseVM.groups[indexPath.section]
        return headerView
    }
}