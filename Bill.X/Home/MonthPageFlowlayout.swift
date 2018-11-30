//
//  MonthPageFlowlayout.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/29.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthPageFlowlayout: UICollectionViewFlowLayout {

    public var column : Int
    public var row : Int
    
    public var horizontallyMargin = 10.0
    public var verticalMargin = 10.0
    
    public init(with row : Int = 1 , column : Int = 1) {
        
        self.row = row
        self.column = column
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var allAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        allAttributes.removeAll()
        
        let numberOfRows = collectionView?.numberOfItems(inSection: 0)
        for index in 0..<numberOfRows! {
            
            let indexPath = IndexPath.init(row: index, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)
            if let attributes = attributes {
                allAttributes.append(attributes)
            }
        }
    }
    
    override var collectionViewContentSize: CGSize{
        get {
            if let collectionView = collectionView{
                
                let cellWidth = (Double(collectionView.frame.width) - Double(column) * horizontallyMargin) / Double(column)
                let numberOfRows = collectionView.numberOfItems(inSection: 0)
                
                let numberOfPageRows = row * column
                //    // 余数（用于确定最后一页展示的item个数）
                let remainder = numberOfRows % numberOfPageRows
                var pageNumber = numberOfRows / numberOfPageRows

                if numberOfRows <= numberOfPageRows {
                    pageNumber = 1
                } else {
                    if remainder != 0 {
                        pageNumber += 1
                    }
                }
                
                var width = 0.0
                if pageNumber > 1 && remainder != 0 && remainder < self.column {
                    width = Double((pageNumber - 1) * self.column)
                    width *= (cellWidth + horizontallyMargin)
                    width += Double(remainder) * cellWidth
                    width += Double(remainder - 1) * horizontallyMargin
                    
                } else {
                    width = Double(pageNumber * self.column) * (cellWidth + horizontallyMargin) - horizontallyMargin
                }
                return CGSize.init(width: width, height: Double(collectionView.frame.height))
            }
            
            return .zero
        }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
     
        let itemWidth = (Double(collectionView!.frame.width) - Double(Double(self.column) * self.horizontallyMargin)) / Double(self.column)
        let itemHeight = (Double(collectionView!.frame.width) - Double(Double(self.row) * self.verticalMargin * Double(self.row - 1))) / Double(self.row)
        
        let item = indexPath.item
        
        let pageNumber = item / row * column
        let x = item % column + pageNumber * column
        let y = item / column - pageNumber * row
        
        let itemX = (itemWidth + self.horizontallyMargin) * Double(x)
        let itemY = (itemHeight + self.verticalMargin) * Double(y)
        let attributes = super.layoutAttributesForItem(at: indexPath)
        attributes?.frame = CGRect.init(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return allAttributes
    }
}

let kEmotionCellNumberOfOneRow = 2
let kEmotionCellRow = 2

class LXFChatEmotionCollectionLayout: UICollectionViewFlowLayout {
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
        
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
        
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
