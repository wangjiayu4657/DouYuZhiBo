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

class BaseAnchorViewController: BaseViewController {

    var baseVM:BaseViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }
    var sectionInsetTop:CGFloat = 0 {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: sectionInsetTop, left: 0, bottom: 0, right: 0)
        }
    }
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
        
//        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
//        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
//        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kCellHeaderViewID)
        
        collectionView.register(CollectionNormalCell.self)
        collectionView.register(CollectionPrettyCell.self)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind:UICollectionView.elementKindSectionHeader)
        
        
        collectionView.backgroundColor = UIColor.white
        collectionView.delegate = self  
        collectionView.dataSource = self
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
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
    override func  setupUI() {
        //父类中的内容视图赋值
        contentView = collectionView
        
        //添加collectionView
        view.addSubview(collectionView)
        
        //调用父类的setupUI (为了让 collectionView 先隐藏,加载完数据后在显示)
        super.setupUI()
    }
}

// MARK: - 遵守UICollectionViewDataSource协议
extension BaseAnchorViewController : UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return baseVM?.groups.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return baseVM?.groups[section].anchors.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        
        let cell = collectionView.dequeueReusableCell(indexPath: indexPath) as CollectionNormalCell
        cell.anchor = baseVM!.groups[indexPath.section].anchors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kCellHeaderViewID, for: indexPath) as! CollectionHeaderView
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, indexPath: indexPath) as CollectionHeaderView
        headerView.groupModel = baseVM!.groups[indexPath.section]
        return headerView
    }
}

extension BaseAnchorViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let anchor = baseVM?.groups[indexPath.section].anchors[indexPath.item]
        anchor?.isVertical == 0 ? normalRoomVC() : showRoomVC()
        
    }
    
    private func showRoomVC() {
        let showRoomVC = ShowRoomViewController()
       navigationController?.present(showRoomVC, animated: true, completion: nil)
    }
    
    private func normalRoomVC() {
//        let normalRoomVC = NormalRoomViewController()
        let normalRoomVC = RoomViewController()
        navigationController?.pushViewController(normalRoomVC, animated: true)
    }
}


// MARK: - 请求数据
extension BaseAnchorViewController {
    //swift4 要想方法被重写必须要在该方法前面加上@objc 关键字
    @objc func requstData() {
        
    }
}
