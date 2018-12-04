//
//  RecomendGameView.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/29.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

private let kGameCellID = "kGameCellID"

class RecomendGameView: UIView {

    // MARK: - 控件
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - 定义数据模型
    var groups:[BaseGameModel]? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    // MARK: - 系统回调
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autoresizingMask = UIView.AutoresizingMask()
        //注册 cell
        collectionView.register(UINib(nibName: "CollectionGameCell", bundle: nil), forCellWithReuseIdentifier: kGameCellID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = AmuseMenuLayout(direction: .horizontal)
        layout.rows = 1
        collectionView.collectionViewLayout = layout
    }
}

extension RecomendGameView {
    static func gameView() -> RecomendGameView {
        return Bundle.main.loadNibNamed("RecomendGameView", owner: nil, options: nil)?.first as! RecomendGameView
    }
}

// MARK: - 遵守UICollectionViewDataSource协议
extension RecomendGameView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGameCellID, for: indexPath) as! CollectionGameCell
        cell.game = groups![indexPath.item]
        
        return cell
    }
}
