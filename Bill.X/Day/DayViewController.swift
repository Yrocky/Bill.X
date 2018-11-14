//
//  DayViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import CoreGraphics

class DayViewController: UIViewController{

    let timeLabel = UILabel()
    let moneyLabel = UILabel()
    let wasteView = DayWasteContainerView()
    var addButton = AddBillEventButton()
    lazy var billCollectionView : UICollectionView = {
        
        let layout = UICollectionViewLeftAlignedLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.estimatedItemSize = CGSize.init(width: 50, height: 42)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0
        
        let c = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        c.delegate = self
        c.dataSource = self
        c.backgroundView = nil
        c.backgroundColor = .clear
        c.showsVerticalScrollIndicator = false
        c.register(CostItemCCell.self, forCellWithReuseIdentifier: "CostItemCCell")
        return c
    }()

    var longPressGesture : UILongPressGestureRecognizer?
    
    var dayEventWrap : BillDayEventWrap?
    
    public init(with dayEventWrap : BillDayEventWrap ) {
        self.dayEventWrap = dayEventWrap
        super.init(nibName: nil, bundle: nil)
        longPressGesture = UILongPressGestureRecognizer.init(target: self,
                                                             action: #selector(DayViewController.onLongPressAction))
        longPressGesture!.delegate = self as UIGestureRecognizerDelegate
        self.longPressGesture!.minimumPressDuration = 0.75
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addGestureRecognizer(self.longPressGesture!)
        view.backgroundColor = .white
        view.addSubview(self.timeLabel)
        view.addSubview(self.moneyLabel)
        view.addSubview(self.wasteView)
        view.addSubview(self.billCollectionView)
        view.addSubview(self.addButton)
        
        timeLabel.textColor = .billBlue
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.billDINBold(50)
        
        moneyLabel.textColor = .billBlack
        moneyLabel.textAlignment = .left
        moneyLabel.font = UIFont.billPingFangSemibold(30)
        
        self.timeLabel.text = "\(String(describing: dayEventWrap!.month))-\(String(describing: dayEventWrap!.day))"
        self.moneyLabel.text = "￥\(String(describing: dayEventWrap!.totalBill))"
        
        self.addButton.addTarget(self,
                                 action: #selector(DayViewController.onAddItemAction),
                                 for: .touchUpInside)
        
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
        wasteView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(timeLabel).offset(16)
            make.bottom.equalTo(moneyLabel.snp.bottom).offset(-16)
            make.width.equalToSuperview().multipliedBy(0.5)
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
    
    @objc func onLongPressAction() {
        print("开始移动")
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

extension DayViewController : UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dayEventWrap = dayEventWrap {
            return dayEventWrap.eventWraps.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let dayEventWrap = dayEventWrap {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CostItemCCell", for: indexPath) as! CostItemCCell
            let eventWrap = dayEventWrap.eventWraps[indexPath.item]
            cell.update(with: eventWrap)
            
            return cell
        }
        return UICollectionViewCell()
    }
}

extension DayViewController : UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
}
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
    public func setBackgroundImageWith(_ color : UIColor, for state : UIControl.State){
        self.setBackgroundImage(UIImage.imageWith(color), for: state)
    }
}
