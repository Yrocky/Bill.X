//
//  MonthContentView.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit

class MonthContentView : UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private(set) var contentView : UICollectionView
    
    private var dayEventWraps : [BillDayEventWrap] = []
    
    override init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.init(top: 7, left: 7.0, bottom: 20, right: 7.0)
        layout.minimumLineSpacing = 7.0
        layout.minimumInteritemSpacing = 7.0
        
        self.contentView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        
        backgroundColor = .clear
        contentView.delegate = self
        contentView.dataSource = self
        contentView.register(DayView.self, forCellWithReuseIdentifier: "DayView")
        contentView.backgroundColor = .white
        addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    public func updateData(with dayEventWraps : [BillDayEventWrap]) {
        
        self.dayEventWraps.removeAll()
        self.dayEventWraps.append(contentsOf: dayEventWraps)
        self.contentView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayEventWraps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayView", for: indexPath) as! DayView
        
        cell.update(with: dayEventWraps[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (collectionView.frame.width - 8 * 7.0) / 7.0
        let height = (collectionView.frame.height - 6 * 7.0 - 20) / 6.0
        return CGSize.init(width: width, height: height)
    }
}
