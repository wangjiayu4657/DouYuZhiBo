//
//  GameViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit


private let kMargin:CGFloat = 10
private let kItemW:CGFloat = (kScreenW - kMargin * 2) / 3
private let kItemH:CGFloat = kItemW * 6 / 5

private let kGameCellID = "kGameCellID"

class GameViewController: UIViewController {

    // MARK: - 懒加载属性
    private lazy var gameVM:GameViewModel = GameViewModel()
    private lazy var collectionView:UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: kMargin, bottom: 0, right: kMargin)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        collectionView.dataSource = self
        return collectionView
    }()
//    private lazy var topHeaderView:CollectionHeaderView = {
//        
//    }()
    
    // MARK: - 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.magenta
        
        setupUI()
        
        requestGameData()
    }
}

// MARK: - 设置 UI
extension GameViewController {
    private func setupUI() {
        view.addSubview(collectionView)
    }
}

// MARK: - 遵守UIcollectionView的数据源协议
extension GameViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gameVM.games.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        cell.game = gameVM.games[indexPath.item]
        return cell
    }
}

// MARK: - 网络请求
extension GameViewController {
    private func requestGameData() {
        gameVM.gameRequest {
            self.collectionView.reloadData()
        }
    }
}
