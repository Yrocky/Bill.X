//
//  DayViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import CoreGraphics

extension UIImage {
    public class func imageWith(_ color : UIColor) -> UIImage {
        return self.imageWith(color, with: CGRect.init(origin: .zero, size: CGSize.init(width: 1, height: 1)))
    }
    public class func imageWith(_ color : UIColor , with frame : CGRect) -> UIImage {
        UIGraphicsBeginImageContext(frame.size)
        let cxt = UIGraphicsGetCurrentContext()
        cxt?.setFillColor(color.cgColor)
        cxt?.fill(frame)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension UIButton : BillRoundShadowViewEnable{
    public func setBackgroundImageWith(_ color : UIColor, for state : UIControlState){
        self.setBackgroundImage(UIImage.imageWith(color), for: state)
    }
}

class DayViewController: UIViewController ,
UICollectionViewDataSource,
UICollectionViewDelegateLeftAlignedLayout{

    let timeLabel = UILabel()
    let moneyLabel = UILabel()
    lazy var addButton : UIButton = {
        let b = UIButton.init(type: .custom)
        b.addTarget(self, action: #selector(DayViewController.onAddItemAction), for: .touchUpInside)
        b.setBackgroundImageWith(.billOrange, for: .normal)
        b.setBackgroundImageWith(.billOrangeHighlight, for: .highlighted)
        b.setTitle("Add Now", for: .normal)
        b.layer.masksToBounds = true
        b.titleLabel?.font = UIFont.billPingFangMedium(25)
        b.setTitleColor(.white, for: .normal)
        b.addRoundShadowFor(b, cornerRadius: 10)
        return b
    }()
    lazy var billCollectionView : UICollectionView = {
        
        let layout = AlignmentLeftLayout()
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10)
        layout.estimatedItemSize = CGSize.init(width: 50, height: 42)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 1.0
        
        let c = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        c.delegate = self
        c.dataSource = self
        c.backgroundView = nil
        c.backgroundColor = .clear
        c.showsVerticalScrollIndicator = false
        c.register(CostItemCCell.self, forCellWithReuseIdentifier: "CostItemCCell")
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(self.timeLabel)
        view.addSubview(self.moneyLabel)
        view.addSubview(self.billCollectionView)
        view.addSubview(self.addButton)
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(timeLabel)
            make.height.equalTo(40)
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
        }
        billCollectionView.snp.makeConstraints { (make) in
            make.left.right.equalTo(moneyLabel)
            make.top.equalTo(moneyLabel.snp.bottom).offset(20)
            make.bottom.equalTo(self.addButton.snp.top).offset(-40)
        }
        addButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-40)
        }
    }
    
    @objc func onAddItemAction() {
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 29
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CostItemCCell", for: indexPath)
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
