//
//  CollectionCycleCell.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/29.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class CollectionCycleCell: UICollectionViewCell {
    // MARK: - 控件属性
    @IBOutlet weak var cycleIcon: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    
    // MARK: - 定义模型属性
    var anchor:CycleModel? {
        didSet {
            guard let anchor = anchor else { return }
            cycleIcon.kf.setImage(with:URL(string: anchor.pic_url))
            titleLb.text = anchor.title
        }
    }
}
