//
//  CollectionGameCell.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/29.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class CollectionGameCell: UICollectionViewCell {

    // MARK: - 控件
    @IBOutlet weak var gameIcon: UIImageView!
    @IBOutlet weak var gameNameLb: UILabel!
    
    // MARK: - 定义数据模型
    var game:BaseGameModel? {
        didSet {
            guard let game = game else { return }
            gameNameLb.text = game.tag_name
            let url = URL(string: game.icon_url)
            gameIcon.kf.setImage(with: url, placeholder: UIImage.init(named: "home_more_btn"))
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
