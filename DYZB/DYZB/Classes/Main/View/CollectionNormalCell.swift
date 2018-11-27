//
//  CollectionNormalCell.swift
//  DYZB
//
//  Created by wangjiayu on 2018/11/23.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {

    // MARK: - 控件
    @IBOutlet weak var roomNameLb: UILabel!
    
    override var anchor:AnchorModel? {
        didSet{
            guard let anchor = anchor else { return }
            
            //显示房间名称
            roomNameLb.text = anchor.room_name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
