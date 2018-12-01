//
//  BaseAnchorViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/1.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit


// MARK: - 定义常量
private let kItemMargin:CGFloat = 10

let kNormalItemW = (kScreenW - 3 * kItemMargin) / 2
let kNormalItemH = kNormalItemW * 3 / 4
let kPrettyItemH = kNormalItemW * 4 / 3



let kPrettyCellID = "kPrettyCellID"
private let kNormalCellID = "kNormalCellID"
private let kCellHeaderViewID = "kCellHeaderViewID"

class BaseAnchorViewController: UIViewController {

    var baseVM:BaseViewModel!
    // MARK: - 懒加载
     lazy var collectionView:UICollectionView = {
        //创建 collectionView 的布局样式
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kNormalItemW, height: kNormalItemH)
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
        collectionView.delegate = self as? UICollectionViewDelegate 
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
extension BaseAnchorViewController {
    @objc func  setupUI() {
        view.addSubview(collectionView)
    }
}

// MARK: - 遵守UICollectionViewDataSource协议
extension BaseAnchorViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return baseVM.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseVM.groups[section].anchors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        
        cell.anchor = baseVM.groups[indexPath.section].anchors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kCellHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.groupModel = baseVM.groups[indexPath.section]
        return headerView
    }
}
// MARK: - 请求数据
extension BaseAnchorViewController {
    //swift4 要想方法被重写必须要在该方法前面加上@objc 关键字
    @objc func requstData() {
        
    }
}
