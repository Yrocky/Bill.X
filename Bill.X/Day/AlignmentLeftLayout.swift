//
//  AlignmentLeftLayout.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/10.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

extension UICollectionViewLayoutAttributes{

    public func leftAlignFrameWith(_ sectionInset : UIEdgeInsets){
        var frame = self.frame
        frame.origin.x = sectionInset.left
        self.frame = frame
    }
}

protocol UICollectionViewDelegateLeftAlignedLayout : UICollectionViewDelegateFlowLayout{
    
}

class AlignmentLeftLayout: UICollectionViewFlowLayout {

    private func evaluatedSectionInsetForItemAt(_ index : Int) -> UIEdgeInsets {
        
        if (collectionView?.delegate?.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:insetForSectionAt:))))! {
            
            let delegate = self.collectionView?.delegate as! UICollectionViewDelegateLeftAlignedLayout
            return delegate.collectionView!(self.collectionView!, layout: self, insetForSectionAt: index)
        }
        return sectionInset
    }

    private func evaluatedMinimumInteritemSpacingForSectionAt(_ index : Int) -> CGFloat {
        
        if (collectionView?.delegate?.responds(to: #selector(UICollectionViewDelegateFlowLayout.collectionView(_:layout:minimumInteritemSpacingForSectionAt:))))! {
            
            let delegate = self.collectionView?.delegate as! UICollectionViewDelegateLeftAlignedLayout
            return delegate.collectionView!(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: index)
        }
        return minimumInteritemSpacing
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let originalAttributes = super.layoutAttributesForElements(in: rect)
        var updatedAttributes = NSMutableArray.init(array: originalAttributes!) as! [UICollectionViewLayoutAttributes]
        
        for attributes : UICollectionViewLayoutAttributes in originalAttributes! {
            if ((attributes.representedElementKind != nil)){
                let index = updatedAttributes.index(of: attributes)
                updatedAttributes[index!] = self.layoutAttributesForItem(at: attributes.indexPath)!
            }
        }
        return updatedAttributes
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let currentItemAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as! UICollectionViewLayoutAttributes
        
        let sectionInset = self.evaluatedSectionInsetForItemAt(indexPath.section)
        let isFirstItemInSection = indexPath.item == 0
        let layoutWidth = (self.collectionView?.frame.width)! - sectionInset.left - sectionInset.right
        
        if isFirstItemInSection {
            currentItemAttributes.leftAlignFrameWith(sectionInset)
            return currentItemAttributes
        }
        
        let preIndexPath = NSIndexPath.init(item: indexPath.item - 1, section: indexPath.section)
        let preFrame = self.layoutAttributesForItem(at: preIndexPath as IndexPath)?.frame
        let preOriginalX = (preFrame?.minX)! + (preFrame?.width)!
        let currentFrame = currentItemAttributes.frame
        let strecthedCurrentFrame = CGRect.init(x: sectionInset.left,
                                                y: currentFrame.minY,
                                                width: layoutWidth,
                                                height: currentFrame.height)
        let isFirstItemInRow = !CGRect.intersects(preFrame!)(strecthedCurrentFrame)
        if isFirstItemInRow {
            currentItemAttributes.leftAlignFrameWith(sectionInset)
            return currentItemAttributes
        }
        
        var frame = currentItemAttributes.frame
        frame.origin.x = preOriginalX + self.evaluatedMinimumInteritemSpacingForSectionAt(indexPath.section)
        currentItemAttributes.frame = frame
        
        return currentItemAttributes
    }
}
