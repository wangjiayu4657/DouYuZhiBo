//
//  FunnyViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/2.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

class FunnyViewController: BaseAnchorViewController {

    // MARK: - 懒加载
    private let funnyVM:FunnyViewModel = FunnyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.magenta
    }
    
    
}

// MARK: - 设置 UI
extension FunnyViewController {
    override func setupUI() {
        super.setupUI()
        
        sectionInsetTop = 8
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.headerReferenceSize = CGSize.zero
    }
}

// MARK: - 请求数据
extension FunnyViewController {
    override func requstData() {
        baseVM = funnyVM
        
        funnyVM.funnyRequest {
            self.collectionView.reloadData()
        }
    }
}
