//
//  NormalRoomViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/2.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

private let kNormalCellID = "kNormalCellID"

class NormalRoomViewController: UIViewController {
    
    private var count = 30
    // MARK: - 懒加载
    private lazy var collectionView:UICollectionView = { [unowned self] in
        let layout = AmuseMenuLayout(direction: DirectionLayout.vertical)
        layout.dataSource = self
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.cols = 2
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kNormalCellID)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

// MARK: - 设置 UI
extension NormalRoomViewController {
    private func setupUI() {
        view.addSubview(collectionView)
    }
}


// MARK: - 遵守UICollectionViewDataSource协议
extension NormalRoomViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}

// MARK: - 遵守UICollectionViewDelegate协议
extension NormalRoomViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellLayer = CAEmitterLayerManager(image: UIImage(named: "home_header_hot")!,layer:view.layer, postion: CGPoint(x: kScreenW - 30, y: kScreenH - 10))

        cellLayer.startEmitterCellAnimation()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.height {
            count += 30
            collectionView.reloadData()
        }
    }
}


extension NormalRoomViewController : AmuseMenuLayoutDataSource {
    func amuseMenuLayout(_ layout: AmuseMenuLayout, index: Int) -> CGFloat {
        return index % 2 == 0 ? (kScreenW * 2 / 3) : (kScreenW * 0.5)
    }
}

// MARK: - 隐藏导航后依然保持左边栏的 pop 手势
extension NormalRoomViewController : UINavigationControllerDelegate {
    
    func popEnable() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
}



