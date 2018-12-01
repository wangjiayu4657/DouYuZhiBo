//
//  AmuseLayout.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/1.
//  Copyright © 2018 wangjiayu. All rights reserved.
//


import UIKit

class AmuseMenuLayout: UICollectionViewLayout {
    var rows:Int = 2                                        //默认行数
    var cols:Int = 4                                        //默认列数
    var totalWidth:CGFloat = 0                              //默认 collectionView contentSize 的总宽度
    var minimumLineSpacing:CGFloat = 0                      //默认行间距
    var minimumInteritemSpacing:CGFloat = 0                 //默认列间距
    var sectionInset:UIEdgeInsets = UIEdgeInsets.zero       //默认内边距
    lazy var attributes:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
}

extension AmuseMenuLayout {
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        let width = collectionView.bounds.width
        let height = collectionView.bounds.height
        
        //计算 item的 size
        let itemW:CGFloat = (width - sectionInset.left - sectionInset.right - CGFloat((cols - 1)) * minimumInteritemSpacing) / CGFloat(cols)
        let itemH:CGFloat = (height - sectionInset.top - sectionInset.bottom - CGFloat(rows - 1) * minimumLineSpacing) / CGFloat(rows)
        
        //定义总共滚动的页数
        var previousPageOfNums:CGFloat = 0
        
        //获取总组数
        let sections = collectionView.numberOfSections
        //遍历每一组获取每组的 item 个数
        for section in 0..<sections {
            //取出每组总的 item 数
            let items = collectionView.numberOfItems(inSection: section)
            //遍历每个 item 设置 frame
            for item in 0..<items {
                //创建布局对象
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                //当前组内 item 所在的页数
                let currentPage:Int = item / (cols * rows)
                //当前页内 item 所在位置
                let currentIndex:Int = item % (cols * rows)
                
                let itemX:CGFloat = (previousPageOfNums + CGFloat(currentPage)) * width + sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat((currentIndex % cols))
                let itemY:CGFloat = sectionInset.top + (itemH + minimumLineSpacing) * CGFloat((currentIndex / cols))
                attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
                
                attributes.append(attribute)
            }
            
            previousPageOfNums += CGFloat((items - 1) / (cols * rows) + 1)
        }
        
        totalWidth = previousPageOfNums * width
    }
}

extension AmuseMenuLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}

extension AmuseMenuLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: totalWidth, height: 0)
    }
}
