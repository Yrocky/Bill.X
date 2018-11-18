//
//  DayViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/9.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import CoreGraphics
import EventKit

class DayViewController: BillViewController{

    enum HandleCellStatus {
        case none
        case struggle
        case leave
        case remove
    }
    
    struct DayHandleCellWrap {
    
        var cell : CostItemCCell?
        var eventWrap : BillEventWrap?
        var cellStatus = HandleCellStatus.none
        var frame = CGRect.zero
        var center = CGPoint.zero
        var indexPath = IndexPath.init()
        
        var struggleOffset : CGFloat {
            get {
                return self.frame.height * 1
            }
        }
        
        mutating func update(frame : CGRect , center : CGPoint) {
            self.frame = frame
            self.center = center
        }
        
        mutating func reset() {
            self.frame = .zero
            self.center = .zero
            self.cell = nil
            self.cellStatus = .none
            self.indexPath = IndexPath.init()
            self.eventWrap = nil
        }
    }
    
    var handleWrap : DayHandleCellWrap?

    let timeLabel = UILabel()
    let moneyLabel = UILabel()
    var snapshot : UIView?
    let wasteView = DayWasteContainerView()
    var addButton = BillHandleButton.init(with: "Add now")
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

    var longPressGesture : UIPanGestureRecognizer?
    
    var dayEventWrap : BillDayEventWrap?
    
    public init(with dayEventWrap : BillDayEventWrap ) {
        self.dayEventWrap = dayEventWrap
        super.init(nibName: nil, bundle: nil)
        longPressGesture = UIPanGestureRecognizer.init(target: self,
                                                       action: #selector(self.onLongPressAction(_:)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(self.timeLabel)
        view.addSubview(self.moneyLabel)
        view.addSubview(self.wasteView)
        view.addSubview(self.billCollectionView)
        view.addSubview(self.addButton)
        view.addGestureRecognizer(self.longPressGesture!)
        
        timeLabel.textColor = .billBlue
        timeLabel.textAlignment = .left
        timeLabel.font = UIFont.billDINBold(50)
        
        moneyLabel.textColor = .billBlack
        moneyLabel.textAlignment = .left
        moneyLabel.font = UIFont.billPingFangSemibold(30)
        
        self.timeLabel.text = "\(String(describing: dayEventWrap!.month))-\(String(describing: dayEventWrap!.day))"
        self.moneyLabel.text = "￥\(String(describing: dayEventWrap!.totalBill))".billMoneyFormatter
        
        self.addButton.addTarget(self,
                                 action: #selector(self.onAddItemAction),
                                 for: .touchUpInside)
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
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
            make.right.equalTo(-20)
            make.height.equalTo(50)
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-40)
        }
    }
    
    @objc override func onEventChange() {
        
        BillEventKitSupport.support.fetchBillEvent(year: self.dayEventWrap!.year, month: self.dayEventWrap!.month, day: self.dayEventWrap!.day) { (eventWraps) in
            
            self.dayEventWrap?.eventWraps = eventWraps
            self.updateDayBillEvent()
        }
    }
    
    private func updateDayBillEvent() {
        
        self.moneyLabel.text = "￥\(String(describing: dayEventWrap!.totalBill))".billMoneyFormatter
        
        self.billCollectionView.reloadSections(IndexSet.init(integer: 0))
    }
    
    @objc func onAddItemAction() {
        
        let edit = EditBillViewController.init(with: nil)
        self.navigationController?.pushViewController(edit, animated: true)
    }
    
    @objc func onLongPressAction(_ gesture: UIPanGestureRecognizer) {
        
        if gesture.state == .began {
            
            if let indexPath = billCollectionView.indexPathForItem(at: gesture.location(in: self.billCollectionView)) {
            
                if let cell = billCollectionView.cellForItem(at: indexPath) {
                    cell.isHighlighted = false
                    
                    let handleCellFrame = cell.convert(cell.bounds, to: self.view)
                    let handleCellCenter = CGPoint.init(x: handleCellFrame.minX + handleCellFrame.width * 0.5,
                                                        y: handleCellFrame.minY + handleCellFrame.height * 0.5)
                    
                    self.handleWrap = DayHandleCellWrap()
                    self.handleWrap?.cell = cell as? CostItemCCell
                    self.handleWrap?.eventWrap = self.dayEventWrap?.eventWraps[indexPath.item]
                    self.handleWrap?.update(frame: handleCellFrame, center: handleCellCenter)
                    self.handleWrap?.indexPath = indexPath
                    
                    self.snapshot = cell.snapshotView(afterScreenUpdates: true)
                    self.snapshot?.center = handleCellCenter
                    self.snapshot?.bounds = cell.bounds
                    self.snapshot?.layer.cornerRadius = handleCellFrame.height * 0.5
                    self.snapshot?.layer.shadowColor = UIColor.billBlue.cgColor
                    self.snapshot?.layer.shadowOffset = CGSize.init(width: 2, height: 0)
                    self.snapshot?.layer.shadowRadius = 6
                    self.snapshot?.layer.shadowOpacity = 0.4
                    view.addSubview(self.snapshot!)
                    
                    cell.isHidden = true
                }
            }
        }
        else if gesture.state == .changed {
            
            if let snapshotView = self.snapshot ,let handleCell = handleWrap?.cell{
                
                let translation = gesture.translation(in: handleCell)
                var centerX = self.handleWrap!.center.x + translation.x
                var centerY = self.handleWrap!.center.y + translation.y
                
                if abs(translation.x) < self.handleWrap!.struggleOffset
                    && abs(translation.y) < self.handleWrap!.struggleOffset
                    && handleWrap?.cellStatus != .leave {///
                    
                    let offsetX = translation.x > 0 ? pow(translation.x, 0.6) : -pow(-translation.x, 0.6)
                    let offsetY = translation.y > 0 ? pow(translation.y, 0.6) : -pow(-translation.y, 0.6)
                    centerX = self.handleWrap!.center.x + offsetX
                    centerY = self.handleWrap!.center.y + offsetY
                    
                    handleWrap?.cellStatus = .struggle
                } else {
                    if handleWrap?.cellStatus == .struggle {
                        
                        billCollectionView.performBatchUpdates({
                            
                            let indexPath = self.billCollectionView.indexPath(for: handleCell)
                            self.dayEventWrap?.eventWraps.remove(at: indexPath!.item)
                            self.billCollectionView.deleteItems(at: [indexPath!])
                        }) { (_) in
                        }
                    }
                    handleWrap?.cellStatus = .leave
                    
                    let minCenterX = 16 + self.handleWrap!.frame.width * 0.5
                    let maxCenterX = self.view.frame.width - 16 - self.handleWrap!.frame.width * 0.5
                    let minCenterY = self.billCollectionView.frame.minY + self.handleWrap!.frame.height * 0.5
                    let maxCenterY = self.addButton.frame.maxY - self.handleWrap!.frame.height * 0.5
                    
                    centerX = min(max(minCenterX, centerX), maxCenterX)
                    centerY = min(max(minCenterY, centerY), maxCenterY)
                }
                
                snapshotView.center = CGPoint.init(x: centerX,
                                                   y: centerY)
            }
        }
        else {
            
            if self.handleWrap?.cellStatus == .struggle {
                self.handleWrap?.cell?.isHidden = false
                if let snapshot = self.snapshot {
                    
                    let animator = UIViewPropertyAnimator.init(duration: 0.28, dampingRatio: 0.55) {
                        snapshot.center = self.handleWrap!.center
                        snapshot.layer.shadowColor = UIColor.clear.cgColor
                        self.handleWrap?.cell?.isHidden = false
                    }
                    animator.startAnimation()
                    animator.addCompletion { (position) in
                        if position == .end {
                            snapshot.removeFromSuperview()
                            self.snapshot = nil
                        }
                    }
                }
            }
            else if self.handleWrap?.cellStatus == .leave {
                //加回去CollectionView
                if let eventWrap = self.handleWrap?.eventWrap ,let indexPath = self.handleWrap?.indexPath{
                    
                    let animator = UIViewPropertyAnimator.init(duration: 0.28, dampingRatio: 0.55) {
                        self.handleWrap?.cell?.isHidden = false
                        self.snapshot?.center = self.handleWrap!.center
                        self.snapshot?.layer.shadowColor = UIColor.clear.cgColor
                    }
                    animator.startAnimation()
                    animator.addCompletion { (position) in
                        if position == .end {
                            self.snapshot?.removeFromSuperview()
                            self.snapshot = nil
                        }
                    }
                    billCollectionView.performBatchUpdates({
                        
                        self.dayEventWrap?.eventWraps.insert(eventWrap,
                                                             at: indexPath.item)
                        self.billCollectionView.insertItems(at: [indexPath])
                    }, completion: nil)
                }
            }
            else if self.handleWrap?.cellStatus == .remove {
                ///移除snapshot视图
                
            }
            
            self.handleWrap?.reset()
        }
    }
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let dayEventWrap = dayEventWrap {
            let eventWrap = dayEventWrap.eventWraps[indexPath.item]
            print("edit eventWrap:\(eventWrap)")
            let edit = EditBillViewController.init(with: eventWrap)
//            self.navigationController?.present(edit, animated: true, completion: {
//            })
            self.navigationController?.pushViewController(edit, animated: true)
        }
    }
}

