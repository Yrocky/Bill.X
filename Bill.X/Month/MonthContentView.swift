//
//  MonthContentView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

@objc
public protocol MonthContentViewDelegate : class{///<现在的协议需要声明是class-only的
    
    @objc optional func monentContentViewDidSelected(at index : Int ,cell : UIView) -> Void
}

class MonthContentView : UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private(set) var contentView : UICollectionView
    private var year = 0
    private var month = 0
    
    public var dayEventWraps : [BillDayEventWrap] = []
    
    public weak var delegate : MonthContentViewDelegate?
    
    override init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 7.0, bottom: 20, right: 7.0)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 7.0
        
        self.contentView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        self.contentView.clipsToBounds = false
        super.init(frame: frame)
        
        clipsToBounds = false
        backgroundColor = .clear
        contentView.delegate = self
        contentView.dataSource = self
        contentView.register(DayCCell.self, forCellWithReuseIdentifier: "DayCCell")
        contentView.backgroundColor = .clear
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func updateData(with dayEventWraps : [BillDayEventWrap] , at year : Int , month : Int) {
        
        self.year = year
        self.month = month
        
        self.dayEventWraps.removeAll()
        self.dayEventWraps.append(contentsOf: dayEventWraps)
        self.contentView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayEventWraps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCCell", for: indexPath) as! DayCCell
        
        cell.update(with: dayEventWraps[indexPath.row],
                    at: self.year,
                    month: self.month)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let sectionInsetV = layout.sectionInset.top + layout.sectionInset.bottom
        let sectionInsetH = layout.sectionInset.left + layout.sectionInset.right
        let lineSpacing = layout.minimumLineSpacing
        let interitemSpacing = layout.minimumInteritemSpacing
        
        let width = (collectionView.frame.width - sectionInsetH - 6 * interitemSpacing) / 7.0
        let height = (collectionView.frame.height - sectionInsetV - 5 * lineSpacing) / 6.0
        return CGSize.init(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        let cell = collectionView.cellForItem(at: indexPath) as! DayCCell
        if cell.status != .invalid {
            if let delegate = delegate {
                delegate.monentContentViewDidSelected!(at: indexPath.item ,cell: cell)
            }
        }
    }
}
