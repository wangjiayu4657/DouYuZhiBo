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

protocol AmuseMenuLayoutDataSource : class {
    func amuseMenuLayout(_ layout:AmuseMenuLayout,index:Int) -> CGFloat
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
    weak var dataSource:AmuseMenuLayoutDataSource?
    lazy var attributes:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    //根据 cols 初始化一个装有sectionInset.top的数组
    private lazy var indexHight:[CGFloat] = Array(repeating: sectionInset.top, count: cols)

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
        
        //计算 itemSize
        let itemW = (width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * minimumInteritemSpacing) / CGFloat(cols)
       
        //获取总 items
        let itemCount = collectionView.numberOfItems(inSection: 0)
        
        for index in attributes.count..<itemCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let itemH:CGFloat = dataSource?.amuseMenuLayout(self, index: index) ?? 100
            //获取数组中最小的高度
            let minHeigth:CGFloat = indexHight.min()!
            //当前 item 所在的列数
            let index = indexHight.firstIndex(of: minHeigth)!
            
            let itemX = sectionInset.left + (itemW + minimumInteritemSpacing) * CGFloat(index)
            let itemY = minHeigth
            
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
            attributes.append(attribute)
            
            indexHight[index] = attribute.frame.maxY + minimumLineSpacing
        }
        
        totalHeight = indexHight.max()! + sectionInset.bottom - minimumLineSpacing
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


