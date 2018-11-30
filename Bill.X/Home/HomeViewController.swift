//
//  HomeViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import EventKit

class AddBillEventButton : UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setBackgroundImageWith(.billOrange, for: .normal)
        self.setBackgroundImageWith(.billOrangeHighlight, for: .highlighted)
        self.setTitle("Add Now", for: .normal)
        self.layer.masksToBounds = true
        self.titleLabel?.font = UIFont.billPingFangMedium(25)
        self.setTitleColor(.white, for: .normal)
        self.addRoundShadowFor(self, cornerRadius: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class HomeViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
    let eventKitSupport = BillEventKitSupport.support
    
    var addButton = AddBillEventButton()

    let animatioinButton : UIButton = {
       
        let button = UIButton.init(type: .system)
        button.setTitle("Animation", for: .normal)
        button.addTarget(self,
                         action: #selector(HomeViewController.animActioin),//Selector(("animActioin")),
                         for: .touchUpInside)
        return button
    }()
    
    lazy var monthView : UICollectionView = {
        
        let minimumLineSpacing : CGFloat = 20.0
        let minimumInteritemSpacing : CGFloat = 20.0

        let layout = LXFChatEmotionCollectionLayout.init()//.init(with: 2, column: 2)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = minimumLineSpacing
        layout.minimumInteritemSpacing = minimumInteritemSpacing

        let v = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .orange
        v.dataSource = self
        v.delegate = self
        v.isPagingEnabled = true
        v.showsHorizontalScrollIndicator = false
        v.showsVerticalScrollIndicator = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "seq"
        
//        titleLabel.attributedText = NSAttributedString.init(string: "Seq",
//                                                            attributes: [.foregroundColor:UIColor.clear,
//                                                                         .font:UIFont.systemFont(ofSize: 50),
//                                                                         .strokeColor:UIColor.blue,
//                                                                         .strokeWidth:1])
        self.titleLabel.textColor = .orange
        view.addSubview(titleLabel)
        view.addSubview(self.monthView)
        view.addSubview(self.addButton)
        view.addSubview(self.animatioinButton)
        
        addButton.addTarget(self,
                            action: #selector(HomeViewController.onAddItemAction),
                            for: .touchUpInside)


        self.monthView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom).offset(20)
            make.bottom.equalTo(addButton.snp.top).offset(-30)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(monthView.snp.bottom)
        }
        animatioinButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom)
            make.size.equalTo(CGSize.init(width: 150, height: 100))
        }
        addButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
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
        cell.updateMonthTotalBill((indexPath.row % 2 == 0 ? 123 : 0), month: "\(indexPath.item + 1)")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let eventWrap = BillEventWrap.eventWrap(with: self.eventKitSupport.eventStore,
                                                money: 42,
                                                usage: "看电影")
        self.eventKitSupport.addBillEvent(eventWrap) { (success) in
            
        }
    }

}
