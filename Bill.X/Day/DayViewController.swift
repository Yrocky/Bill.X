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
        var indexPath : IndexPath?
        
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
            self.indexPath = nil
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
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
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
        moneyLabel.font = UIFont.billDINBold(30)
        
        self.timeLabel.text = "\(String(describing: dayEventWrap!.month))-\(String(describing: dayEventWrap!.day))"
        let money = "\(String(describing: dayEventWrap!.totalBill))".billMoneyFormatter
        
        let symbolStyle : [NSAttributedString.Key : Any] =
            [.foregroundColor:self.moneyLabel.textColor,
             .font:UIFont.billDINBold(20)]
        let moneyStyle : [NSAttributedString.Key : Any] =
            [.foregroundColor:self.moneyLabel.textColor,
             .font:UIFont.billDINBold(30)]
        
        let att = NSMutableAttributedString.init(string: "￥", attributes: symbolStyle)
        att.append(NSAttributedString.init(string: money, attributes: moneyStyle))
        moneyLabel.attributedText = att
        
        self.addButton.addTarget(self,
                                 action: #selector(self.onAddItemAction),
                                 for: .touchUpInside)
        
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(300)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20 + UIDevice.current.statusBarHeight())
            make.height.equalTo(50)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(timeLabel)
            make.height.equalTo(40)
            make.top.equalTo(timeLabel.snp.bottom).offset(20)
        }
        billCollectionView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(moneyLabel.snp.bottom).offset(20)
            make.bottom.equalTo(self.wasteView.snp.top)
        }
        wasteView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.addButton)
            make.bottom.equalTo(self.addButton.snp.top).offset(-20)
            make.height.equalTo(100)
        }
        addButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
        self.showWasteView(false)
        
        self.timeLabel.alpha = 0
        self.moneyLabel.alpha = 0
        addButton.transform = CGAffineTransform.init(translationX: 0, y: 100)
        addButton.alpha = 0
        self.billCollectionView.alpha = 0
    }
    
    public func desLabelRect() -> (CGRect ,CGRect) {
        return (self.timeLabel.frame,self.moneyLabel.frame)
    }
    
    public func show() {
        self.timeLabel.alpha = 1
        self.moneyLabel.alpha = 1
        self.billCollectionView.alpha = 1
        self.billCollectionView.reloadData()
        let animator = UIViewPropertyAnimator.init(duration: 0.4, curve: .easeOut) {
            
            self.addButton.transform = .identity
            self.addButton.alpha = 1
        }
        animator.startAnimation()
        
    }
    
    @objc override func onEventChange() {
        
        BillEventKitSupport.support.fetchBillEvent(year: self.dayEventWrap!.year, month: self.dayEventWrap!.month, day: self.dayEventWrap!.day) { (eventWraps) in
            
            self.dayEventWrap?.eventWraps = eventWraps
            self.updateDayBillEvent()
        }
    }
    
    private func showWasteView(_ show : Bool) {
        
        UIView.animate(withDuration: 0.25) {
            self.wasteView.isHidden = !show
        }
    }
    
    private func updateDayBillEvent() {
        
        let money = "\(String(describing: dayEventWrap!.totalBill))".billMoneyFormatter
        
        let symbolStyle : [NSAttributedString.Key : Any] =
            [.foregroundColor:self.moneyLabel.textColor,
             .font:UIFont.billDINBold(20)]
        let moneyStyle : [NSAttributedString.Key : Any] =
            [.foregroundColor:self.moneyLabel.textColor,
             .font:UIFont.billDINBold(30)]
        
        let att = NSMutableAttributedString.init(string: "￥", attributes: symbolStyle)
        att.append(NSAttributedString.init(string: money, attributes: moneyStyle))
        moneyLabel.attributedText = att
        
        self.billCollectionView.reloadSections(IndexSet.init(integer: 0))
    }
    
    @objc func onAddItemAction() {
        let date = Calendar.current.dateWith(year: self.dayEventWrap!.year,
                                             month: self.dayEventWrap!.month,
                                             day: self.dayEventWrap!.day)
        let edit = EditBillViewController.init(with: nil,date: date)
        edit.transitioningDelegate  = self
        edit.modalPresentationStyle = .custom
        self.present(edit, animated: true, completion: nil)
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
                    
                    let minCenterX = 16 + self.handleWrap!.frame.width * 0.5
                    let maxCenterX = self.view.frame.width - 16 - self.handleWrap!.frame.width * 0.5
                    let minCenterY = self.billCollectionView.frame.minY + self.handleWrap!.frame.height * 0.5
                    let maxCenterY = self.addButton.frame.maxY - self.handleWrap!.frame.height * 0.5
                    
                    centerX = min(max(minCenterX, centerX), maxCenterX)
                    centerY = min(max(minCenterY, centerY), maxCenterY)
                    
                    
                    self.showWasteView(true)
                    let wasteViewFrame = self.wasteView.convert(self.wasteView.bounds,
                                                                to: self.view)
                    let canRemove = wasteViewFrame.contains(CGPoint.init(x: centerX, y: centerY))
                    self.wasteView.makeGarbage(highlight: canRemove)
                    
                    handleWrap?.cellStatus = canRemove ? .remove : .leave
                }
                

                snapshotView.center = CGPoint.init(x: centerX,
                                                   y: centerY)
            }
        }
        else {
            
            /// 隐藏辣鸡视图
            self.showWasteView(false)
            
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
                if let eventWrap = self.handleWrap?.eventWrap {
                    BillEventKitSupport.support.removeBillEvent(eventWrap) { (finish) in
                        
                        if finish {
                            
                            let animator = UIViewPropertyAnimator.init(duration: 0.28, dampingRatio: 0.55) {
                                self.snapshot?.transform = CGAffineTransform.init(scaleX: 0, y: 0)
                                self.snapshot?.layer.shadowColor = UIColor.clear.cgColor
                            }
                            animator.startAnimation()
                            animator.addCompletion { (position) in
                                if position == .end {
                                    self.snapshot?.removeFromSuperview()
                                    self.snapshot = nil
                                }
                            }
                        }
                    }
                }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let transform = CGAffineTransform.init(translationX: 0, y: 10)
//        transform.concatenating(CGAffineTransform.ini)
        cell.transform = transform;
        cell.alpha = 0.4
        let timingParameters = UISpringTimingParameters.init(mass: 2,
                                                         stiffness: 480,
                                                         damping: 25,
                                                         initialVelocity: CGVector.init(dx: 0.3, dy: 0.3))
        let animator = UIViewPropertyAnimator.init(duration: 0.4, timingParameters: timingParameters)
        animator.addAnimations({
            cell.alpha = 1
            cell.transform = .identity
        }, delayFactor: (CGFloat(indexPath.row) * 0.05))
        animator.startAnimation()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if let dayEventWrap = dayEventWrap {
            let eventWrap = dayEventWrap.eventWraps[indexPath.item]
            print("edit eventWrap:\(eventWrap)")
            let edit = EditBillViewController.init(with: eventWrap ,date:eventWrap.date)
            edit.transitioningDelegate  = self
            edit.modalPresentationStyle = .custom
            self.present(edit, animated: true, completion: nil)
//            self.navigationController?.pushViewController(edit, animated: true)
        }
    }
}

extension DayViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented.isKind(of: EditBillViewController.self) {
            return BillEditPresentAnimator()
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.isKind(of: EditBillViewController.self) {
            return BillEditDismissAnimator()
        }
        return nil
    }
}
