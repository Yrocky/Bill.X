//
//  HomeViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import EventKit

class BillHandleButton : UIButton {
    
    public convenience init(with title : String) {
        self.init(frame: .zero)
        self.setTitle(title, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setBackgroundImageWith(.billOrange, for: .normal)
        self.setBackgroundImageWith(.billOrangeHighlight, for: .highlighted)
        self.setBackgroundImageWith(.billOrangeHighlight, for: .disabled)
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont.billPingFangMedium(19)
        self.setTitleColor(.white, for: .normal)
        self.addRoundShadowFor(self, cornerRadius: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeViewController: BillViewController,
UICollectionViewDataSource,
UICollectionViewDelegate {
    
    let eventKitSupport = BillEventKitSupport.support
    
    var addButton = BillHandleButton.init(with: "Add now")

    lazy var monthView : UICollectionView = {
        
        let minimumLineSpacing : CGFloat = 20.0
        let minimumInteritemSpacing : CGFloat = 20.0
        let screenWidth : CGFloat = self.view.frame.width
        let itemWidth : CGFloat = (screenWidth - 2 * 16 - minimumInteritemSpacing) / 2.0
        let itemHeight : CGFloat = (500 - minimumLineSpacing - 2 * minimumLineSpacing) / 2.0
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.itemSize = CGSize.init(width: itemWidth , height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: minimumLineSpacing,
                                           left: 16,
                                           bottom: minimumLineSpacing,
                                           right: 16)
        let v = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .orange
        v.dataSource = self
        v.delegate = self
        v.isPagingEnabled = true
        v.register(MonthCCell.self, forCellWithReuseIdentifier: "MonthCCell")
        return v
    }()
    
    let titleLabel = UILabel()
    
    @objc func animActioin() {

//        let month = MonthViewController()
//        let month = DayViewController()
//        navigationController?.pushViewController(month, animated: true)
        
        
        self.eventKitSupport.fetchBillEventAll { (eventWraps) in
            print("++++all++++============")
            eventWraps.forEach({ (eventWrap) in
                print(eventWrap.event.title)
            })
        }
        self.eventKitSupport.fetchBillEvent(year: 2017, { (eventWraps) in
            print("+++++2017+++============--------")
            eventWraps.forEach({ (eventWrap) in
                print(eventWrap.event.title)
            })
            self.eventKitSupport.arrangeBillEventForYear(eventWraps).forEach({ (monthEventWraps) in
                print(monthEventWraps)
            })
        })
        self.eventKitSupport.fetchBillEvent(year: 2018, month: 11) { (eventWraps) in
            print("++&&2018-11&&&==")
            eventWraps.forEach({ (eventWrap) in
                print(eventWrap.event.title)
            })
//            self.eventKitSupport.arrangeBillEventForMonth(eventWraps, year: 2018 , month : 11)
//                .forEach({ (dayEventWraps) in
//                    print(dayEventWraps)
//                })
        }
        self.eventKitSupport.fetchBillEvent(year: 2018, month: 10) { (eventWraps) in
            print("++++2018-10==")
            eventWraps.forEach({ (eventWrap) in
                print(eventWrap.event.title)
            })
        }
        self.eventKitSupport.fetchBillEvent(year: 2018, month: 11, day: 12, { (eventWraps) in
            
            print("+++++2018-11-12+++=====--")
            eventWraps.forEach({ (eventWrap) in
                print(eventWrap.event.title)
            })
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        if !eventKitSupport.accessGrand {
            eventKitSupport.checkEventStoreAccessForCanendar { (accessGrand) in
                if !accessGrand{
                    print("没有授权读取日历")
                }
            }
        }
    }
    
    @objc override func onEventChange() {
    
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.font = UIFont.billDINBold(60)
        self.titleLabel.text = "2018"
        self.titleLabel.textAlignment = .left
        self.titleLabel.textColor = .billBlue
        view.addSubview(titleLabel)
        view.addSubview(self.monthView)
        view.addSubview(self.addButton)
        
        addButton.addTarget(self,
                            action: #selector(self.onAddItemAction),
                            for: .touchUpInside)


        titleLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.left.equalTo(20)
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(20)
        }
        self.monthView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalTo(addButton.snp.top).offset(-30)
        }
        addButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.equalTo(50)
            make.right.equalTo(-20)
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-40)
        }
    }
    
    @objc func onAddItemAction() {
        
        let month = MonthViewController.init(with: 2018, month: 11)
        navigationController?.pushViewController(month, animated: true)
        
        ///TODO:弹出来添加event视图
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCCell", for: indexPath) as! MonthCCell
        cell.updateMonthTotalBill((indexPath.row % 2 == 0 ? 123 : 0), month: "Seq")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let eventWrap = BillEventWrap.eventWrap(with: self.eventKitSupport,
                                                money: 42,
                                                usage: "看电影")
        self.eventKitSupport.addBillEvent(eventWrap) { (success) in
            
        }
    }

}
