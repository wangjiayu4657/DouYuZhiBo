//
//  GameViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/30.
//  Copyright © 2018 wangjiayu. All rights reserved.
//  游戏界面

import UIKit


private let kMargin:CGFloat = 10
private let kItemW:CGFloat = (kScreenW - kMargin * 2) / 3
private let kItemH:CGFloat = kItemW * 6 / 5
private let kHeaderViewH:CGFloat = 50
private let kGameViewH:CGFloat = 90

private let kGameCellID = "kGameCellID"
private let kHeaderViewID = "kHeaderViewID"

class GameViewController: BaseViewController {

    // MARK: - 懒加载属性
    private lazy var gameVM:GameViewModel = GameViewModel()
    private lazy var collectionView:UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kItemW, height: kItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kMargin, bottom: 0, right: kMargin)
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        collectionView.contentInset = UIEdgeInsets(top: kHeaderViewH + kGameViewH, left: 0, bottom: 0, right: 0 )
        collectionView.dataSource = self
        return collectionView
    }()
    private lazy var topHeaderView:CollectionHeaderView = {
        let topHeaderView = CollectionHeaderView.headerView()
        topHeaderView.frame = CGRect(x: 0, y: -(kHeaderViewH + kGameViewH), width: kScreenW, height: kHeaderViewH)
        topHeaderView.iconView.image = UIImage(named: "Img_orange")
        topHeaderView.titileLabel.text = "常用"
        topHeaderView.moreBtn.isHidden = true
        return topHeaderView
    }()
    private lazy var gameView:RecomendGameView = {
        let gameView = RecomendGameView.gameView()
        gameView.backgroundColor = UIColor.red
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
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
    override func setupUI() {
        //父类中的内容视图赋值
        contentView = collectionView
        //添加collectionView 上的 headerView
        collectionView.addSubview(topHeaderView)
        collectionView.addSubview(gameView)
        view.addSubview(collectionView)
        
        //调用父类的setupUI (为了让 collectionView 先隐藏,加载完数据后在显示)
        super.setupUI()
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        headerView.titileLabel.text = "全部"
        headerView.iconView.image = UIImage(named: "Img_orange")
        headerView.moreBtn.isHidden = true
        return headerView
    }
}

// MARK: - 网络请求
extension GameViewController {
    private func requestGameData() {
        gameVM.gameRequest {
            //展示全部游戏
            self.collectionView.reloadData()

            //展示常用游戏(取前十个数据)
            self.gameView.groups = Array(self.gameVM.games[0..<10])

            //数据请求完成时隐藏加载动画
            self.loadDataFinished()
        }
        
        //面向协议请求
//        gameVM.request {
//            //展示全部游戏
//            self.collectionView.reloadData()
//
//            //展示常用游戏(取前十个数据)
//            self.gameView.groups = Array(self.gameVM.results[0..<10])
//
//            //数据请求完成时隐藏加载动画
//            self.loadDataFinished()
//        }
    }
}
