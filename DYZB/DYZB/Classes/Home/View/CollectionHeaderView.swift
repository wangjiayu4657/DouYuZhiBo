//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/23.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView,Reuseable {
    
    //给协议中的nib 属性赋值
    static var nib:UINib? { return UINib(nibName: "\(self)", bundle: nil)}

    // MARK: - 控件属性
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var moreBtn: UIButton!
    
    var groupModel:AnchorGroup? {
        didSet {
            guard let model = groupModel else { return }
            iconView.image = UIImage(named: model.icon_name ?? "home_header_normal")
            titileLabel.text = model.tag_name
        }
    }
}

extension CollectionHeaderView {
    static func headerView() ->CollectionHeaderView {
        return Bundle.main.loadNibNamed("CollectionHeaderView", owner: nil, options: nil)?.first as! CollectionHeaderView
    }
}
