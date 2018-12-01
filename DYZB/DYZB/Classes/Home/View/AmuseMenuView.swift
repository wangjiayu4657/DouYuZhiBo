////
////  AmuseView.swift
////  DYZB
////
////  Created by wangjiayu on 2018/12/1.
////  Copyright © 2018 wangjiayu. All rights reserved.
////
//
//import UIKit
//
//private let kAmuseCellID = "kamuseCellID"
//
//class AmuseView: UIView {
//    @IBOutlet weak var collectionView: UICollectionView!
//    @IBOutlet weak var pageControl: UIPageControl!
//
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        let layout:AmuseLayout = AmuseLayout()
//        layout.minimumLineSpacing = 5
//        layout.minimumInteritemSpacing = 5
//        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//
//        collectionView.collectionViewLayout = layout
//        collectionView.backgroundColor = UIColor.white
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kAmuseCellID)
//    }
//    //    private lazy var collectionView: UICollectionView = {
////        let layout:AmuseLayout = AmuseLayout()
////        layout.minimumLineSpacing = 5
////        layout.minimumInteritemSpacing = 5
////        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
////
////        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height), collectionViewLayout: layout)
////        collectionView.backgroundColor = UIColor.white
////        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kAmuseCellID)
////        collectionView.isPagingEnabled = true
////        collectionView.showsHorizontalScrollIndicator = false
////        collectionView.dataSource = self
////        return collectionView
////    }()
////
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////
////        addSubview(collectionView)
////    }
////
////    required init?(coder aDecoder: NSCoder) {
////        fatalError("init(coder:) has not been implemented")
////    }
//}
//
//extension AmuseView {
//    static func amuseView() -> AmuseView {
//        return Bundle.main.loadNibNamed("AmuseView", owner: nil, options: nil)?.first as! AmuseView
//    }
//}
//
//extension AmuseView : UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 3
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 27
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAmuseCellID, for: indexPath)
//         cell.backgroundColor = UIColor.randomColor()
//        return cell
//    }
//}


//
//  AmuseView.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/1.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

private let kAmuseCellID = "kamuseCellID"

class AmuseMenuView: UIView {
    
    // MARK: - 控件
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        autoresizingMask = UIView.AutoresizingMask()
        
        let layout:AmuseMenuLayout = AmuseMenuLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        collectionView.collectionViewLayout = layout
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: kAmuseCellID)
//        collectionView.dataSource = self
    }
}

extension AmuseMenuView {
    static func amuseView() ->AmuseMenuView {
        return Bundle.main.loadNibNamed("AmuseMenuView", owner: nil, options: nil)?.first as! AmuseMenuView
    }
}

extension AmuseMenuView : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 27
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kAmuseCellID, for: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}
