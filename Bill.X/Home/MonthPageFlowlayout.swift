//
//  MonthPageFlowlayout.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/29.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthPageFlowlayout: UICollectionViewFlowLayout {
    // 保存所有item
    fileprivate var attributesArr: [UICollectionViewLayoutAttributes] = []
    
    fileprivate var column : Int = 2
    fileprivate var row : Int = 2

    public init(with row : Int = 2 , column : Int = 2) {
        
        self.row = row
        self.column = column
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- 重新布局
    override func prepare() {
        super.prepare()

        let collectionViewWidth = collectionView!.frame.width
        let collectionViewHeight = collectionView!.frame.height
        
        let itemWidth = (collectionViewWidth - (CGFloat(row + 1) * minimumInteritemSpacing)) / CGFloat(row)
        let itemHeight = (collectionViewHeight - collectionView!.contentInset.top - collectionView!.contentInset.bottom - minimumLineSpacing * CGFloat(column + 1)) / CGFloat(column)
        
        // 设置itemSize
        itemSize = CGSize(width: itemWidth,
                          height: itemHeight)
        
        var page = 0
        let itemsCount = collectionView?.numberOfItems(inSection: 0) ?? 0
        
        for itemIndex in 0..<itemsCount {
            let indexPath = IndexPath(item: itemIndex, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            page = itemIndex / (row * column)
            // 通过一系列计算, 得到x, y值
            let x = itemSize.width * CGFloat(itemIndex % Int(column)) + (CGFloat(page) * collectionViewWidth) + minimumInteritemSpacing * CGFloat(itemIndex % Int(column) + 1)
            let y = itemSize.height * CGFloat((itemIndex - page * row * column) / column) + minimumLineSpacing * CGFloat((itemIndex - page * row * column) / column + 1)
            
            attributes.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
            // 把每一个新的属性保存起来
            attributesArr.append(attributes)
        }
        
    }
    override var collectionViewContentSize: CGSize{
        get {
            if let collectionView = collectionView{
                
                let numberOfRows = collectionView.numberOfItems(inSection: 0)
                
                let numberOfPageRows = row * column
                
                //    // 余数（用于确定最后一页展示的item个数）
                let remainder = numberOfRows % numberOfPageRows//取余
                var pageNumber = numberOfRows / numberOfPageRows//求整

                if numberOfRows <= numberOfPageRows {
                    pageNumber = 1
                } else {
                    if remainder != 0 {
                        pageNumber += 1
                    }
                }
                
                return CGSize.init(width: CGFloat(pageNumber) * collectionView.frame.width,
                                   height: collectionView.frame.height)
            }
            
            return .zero
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var rectAttributes: [UICollectionViewLayoutAttributes] = []
        _ = attributesArr.map({
            if rect.contains($0.frame) {
                rectAttributes.append($0)
            }
        })
        return rectAttributes
    }
    
}
