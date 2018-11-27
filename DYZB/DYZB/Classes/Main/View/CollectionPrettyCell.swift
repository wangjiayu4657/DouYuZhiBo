//
//  CollectionPrettyCell.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/23.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionPrettyCell: CollectionBaseCell {


    @IBOutlet weak var cityBtn: UIButton!
    
    override var anchor:AnchorModel? {
        didSet{
            guard let anchor = anchor else { return }

            //显示所在城市
            cityBtn.setTitle(anchor.anchor_city, for: .normal)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
