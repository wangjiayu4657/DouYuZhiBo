//
//  AmuseLayout.swift
//  DYZB
//
//  Created by wangjiayu on 2018/12/1.
//  Copyright © 2018 wangjiayu. All rights reserved.
//


import UIKit

// MARK: - 定义布局方向
enum DirectionLayout {
    case horizontal
    case vertical
}

class AmuseMenuLayout: UICollectionViewLayout {
    var rows:Int = 2                                        //默认行数
    var cols:Int = 4                                        //默认列数
    var totalWidth:CGFloat = 0                              //默认 collectionView contentSize 的总宽度
    var totalHeight:CGFloat = 0                             //默认 collectionView contentSize 的总高度
    var minimumLineSpacing:CGFloat = 0                      //默认行间距
    var minimumInteritemSpacing:CGFloat = 0                 //默认列间距
    var sectionInset:UIEdgeInsets = UIEdgeInsets.zero       //默认内边距
    var layoutDirection:DirectionLayout
    lazy var attributes:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    init(direction:DirectionLayout) {
        layoutDirection = direction
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension AmuseMenuLayout {
    override func prepare() {
        super.prepare()

        layoutDirection == .horizontal ? horizontalLayout() : verticalLayout()
    }
}


// MARK: - 自定义布局
extension AmuseMenuLayout {
    //水平方向
    private func horizontalLayout() {
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
    
    //垂直方向
    private func verticalLayout() {
        
        guard let collectionView = collectionView else { return }
        if cols == 0 { return }
        
        let width = collectionView.bounds.width
//        let height = collectionView.bounds.height
        
        //计算 itemSize
        let itemW = (width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
       
        
        let itemCount = collectionView.numberOfItems(inSection: 0)
        
        //根据 cols 初始化一个装有sectionInset.top的数组
        var indexHight:[CGFloat] = Array(repeating: sectionInset.top, count: cols)
        
        for index in 0..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let itemH = CGFloat(arc4random_uniform(150) + 80)
            //获取数组中最小的高度
            let minHeigth:CGFloat = indexHight.min()!
            //当前 item 所在的列数
            let index = indexHight.firstIndex(of: minHeigth)!
            
            let itemX = sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index) + sectionInset.right
            let itemY = minHeigth + minimumLineSpacing
            
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            attributes.append(attribute)
            
            indexHight[index] = attribute.frame.maxY
        }
        
        totalHeight = indexHight.max()! + sectionInset.bottom
    }
}

extension AmuseMenuLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributes
    }
}

extension AmuseMenuLayout {
    override var collectionViewContentSize: CGSize {
        return CGSize(width: totalWidth, height: totalHeight)
    }
}


