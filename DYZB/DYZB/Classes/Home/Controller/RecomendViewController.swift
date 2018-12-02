//
//  RecomendViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/23.
//  Copyright © 2018 wangjiayu. All rights reserved.
//  推荐界面

import UIKit


// MARK: - 定义常量
private let kCycleViewH:CGFloat = kScreenW * 3 / 8
private let kGameViewH:CGFloat = 90

class RecomendViewController: BaseAnchorViewController {

    // MARK: - 懒加载
    private lazy var recomendVM:RecomendViewModel = RecomendViewModel()
    //轮播图
    private lazy var cycleView:RecomendCycleView = {
       let cycleView = RecomendCycleView.cycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        return cycleView
    }()
    //轮播图下面的游戏推荐
    private lazy var gameView:RecomendGameView = {
       let gameView = RecomendGameView.gameView()
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //请求数据
        loadCycleData()
    }
}

// MARK: -  设置 UI 界面
extension RecomendViewController {
    override func setupUI() {
        super.setupUI()
        //设置collectionView内边距显示头部视图
        sectionInsetTop = kCycleViewH + kGameViewH
        //添加轮播图
        collectionView.addSubview(cycleView)
        //添加游戏推荐视图
        collectionView.addSubview(gameView)
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
    override func requstData() {
        //给 baseViewModel 赋值
        baseVM = recomendVM
        
        recomendVM.requestData {[weak self] in
            self?.collectionView.reloadData()
            
            var groups = self?.recomendVM.groups
            //火热 和 颜值两组不显示
            groups?.removeFirst()
            groups?.removeFirst()
            
            //添加最有一组更多数据
            let groupModel = AnchorGroup()
            groupModel.tag_name = "更多"
            groupModel.icon_url = ""
            groups?.append(groupModel)
            
            self?.gameView.groups = groups
            
            //数据请求完成时隐藏加载动画
            self?.loadDataFinished()
        }
    }
}

//// MARK: - 遵守UICollectionViewDataSource协议
extension RecomendViewController {
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 1 {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath) as! CollectionPrettyCell
            cell.anchor = recomendVM.groups[indexPath.section].anchors[indexPath.item]
            return cell
        }else {
            return super.collectionView(collectionView, cellForItemAt: indexPath)
        }
    }
}
// MARK: - 遵守UICollectionViewDelegate协议
extension RecomendViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1 {
            return CGSize(width: kNormalItemW, height: kPrettyItemH)
        }
        return CGSize(width: kNormalItemW, height: kNormalItemH)
    }
}


