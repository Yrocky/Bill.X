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
UICollectionViewDelegateFlowLayout,
BillMonthPresentAnimatorProtocol{
    
    let eventKitSupport = BillEventKitSupport.support
    
    var addButton = BillHandleButton.init(with: "Add now")
    var monthEventWraps = [BillMonthEventWrap]()
    var year : Int = 2018
    
    var sourceView : UIView?
    
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
        v.backgroundColor = .clear
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
    
        BillEventKitSupport.support.complementedBillEventForYear(year: self.year) { (yearEventWrap) in
            
            self.titleLabel.text = "\(yearEventWrap.year)"
            self.monthEventWraps = yearEventWrap.monthEventWraps
            self.monthView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.font = UIFont.billDINBold(60)
        self.titleLabel.text = "\(self.year)"
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
        
        self.onEventChange()
    }
    
    private func onLoadPreYearEventWraps() {
        
        year -= 1
//        if month != 0 {
//            print("加载前一个月，加载指示器显示 上一个月")
//            self._loadEventWraps(at : month)
//        }else{
//            print("今年的已经查询完毕，加载指示器隐藏")
//        }
    }
    
    private func onLoadNextMonthEventWraps() {
        
        year += 1
//        if month <= 12 {
            print("加载下一个月，加载指示器显示 下一个月")
//            self._loadEventWraps(at : month)
//        }else{
//            print("今年的已经查询完毕，加载指示器隐藏")
//        }
    }
    
    @objc func onAddItemAction() {

        let edit = EditBillViewController.init(with: nil ,date: Date())
        edit.transitioningDelegate  = self
        edit.modalPresentationStyle = .custom
        self.present(edit, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.monthEventWraps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCCell", for: indexPath) as! MonthCCell
        let monthEventWrap = self.monthEventWraps[indexPath.item] as BillMonthEventWrap
        cell.updateMonthTotalBill("\(monthEventWrap.homeTotalBill)".billMoneyFormatter,
                                  month: String.monthString(monthEventWrap.month))
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.sourceView = collectionView.cellForItem(at: indexPath)
        
        let monthEventWrap = self.monthEventWraps[indexPath.item] as BillMonthEventWrap

        let month = MonthViewController.init(with: monthEventWrap.year,
                                             month: monthEventWrap.month)
        self.navigationController?.pushViewController(month, animated: true)
//        month.transitioningDelegate  = self
//        month.modalPresentationStyle = .custom
//        self.present(month, animated: true, completion: nil)
    }
}

extension HomeViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented.isKind(of: EditBillViewController.self) {
            return BillEditPresentAnimator()
        }
        if presented.isKind(of: MonthViewController.self) {
            let monthPresent = BillMonthPresentAnimator()
            monthPresent.delegate = self
            return monthPresent
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.isKind(of: EditBillViewController.self) {
            return BillEditDismissAnimator()
        }
        if dismissed.isKind(of: EditBillViewController.self) {
            return BillMonthDismissAnimator()
        }
        return nil
    }
}
