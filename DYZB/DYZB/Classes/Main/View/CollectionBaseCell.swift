//
//  CollectionBaseCell.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/27.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    // MARK: - 控件
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var nickNameLb: UILabel!
    @IBOutlet weak var onlineBtn: UIButton!
    
    var anchor:AnchorModel? {
        didSet{
            guard let anchor = anchor else { return }
            //显示资源图片
            let iconURL = URL(string: anchor.vertical_src)
            iconView.kf.setImage(with: iconURL)
            
            //显示昵称
            nickNameLb.text = anchor.nickname
            var online = ""
            
            //显示在线人数
            if anchor.online > 10000 {
                online = "\(Int(anchor.online / 10000))万在线"
            }else {
                online = "\(anchor.online)在线"
            }
            onlineBtn.setTitle(online, for: .normal)
        }
    }
}
