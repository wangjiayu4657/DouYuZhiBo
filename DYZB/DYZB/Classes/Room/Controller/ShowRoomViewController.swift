//
//  ShowRoomViewController.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/2.
//  Copyright © 2018 wangjiayu. All rights reserved.
//

import UIKit

private let kPageCollectionCellID = "kPageCollectionCellID"

class ShowRoomViewController: UIViewController {
    
    // MARK: - 懒加载
    private lazy var style:JYPageStyle = {
        var style = JYPageStyle()
        style.isTitleInTop = true
        style.normalColor = UIColor(r: 85, g: 85, b: 85)
        return style
    }()
    private lazy var layout:AmuseMenuLayout = {
        let layout = AmuseMenuLayout(direction: DirectionLayout.horizontal)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.cols = 7
        layout.rows = 3
        return layout
    }()
    private lazy var pageCollectionView:PageCollectionView = { [unowned self] in
        let titles = ["热门","高级","豪华","专属"]
        let pageCollectionView = PageCollectionView(frame: CGRect(x: 0, y: 200, width: kScreenW, height: 300), titles: titles, style: style,layout:layout)
        pageCollectionView.pageRegister(cellClass: UICollectionViewCell.self, forCellWithReuseIdentifier: kPageCollectionCellID)
        pageCollectionView.dataSource = self
        return pageCollectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        setupUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }

}

extension ShowRoomViewController {
    private func setupUI() {
        view.addSubview(pageCollectionView)
    }
}

extension ShowRoomViewController : PageCollectionViewDataSource {
    func pageNumberOfSections(_ pageCollectionView: PageCollectionView) -> Int {
        return 4
    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 100 }
        else if section == 1 { return 19 }
        else if section == 2 { return 37 }
        else { return 31 }
    }
    
    func pageCollectionView(_ pageCollectionView: PageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPageCollectionCellID, for: indexPath)
        return cell
    }
}

