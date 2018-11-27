//
//  CollectionHeaderView.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/23.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    // MARK: - 控件属性
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titileLabel: UILabel!
    
    var groupModel:AnchorGroup? {
        didSet {
            guard let model = groupModel else { return }
            iconView.image = UIImage(named: model.icon_name ?? "home_header_normal")
            titileLabel.text = model.tag_name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
