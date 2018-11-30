//
//  MonthViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import ScrollableGraphView

class MonthViewController: BillViewController , BillDayPresentAnimatorProtocol{

    struct MonthDisplayStatus {
    
        enum DisplayViewType {
            case none
            case graphView
            case dismissView
            case preView
            case nextView
        }
        var displayView : DisplayViewType = .none
        
        var canChangeDisplay : Bool = false
        
        mutating func reset() {
            displayView = .none
            canChangeDisplay = false
        }
    }
    
    private var containerView : UIView?
    private var snapshotView : UIImageView?
    private var monthMaskView : MonthMaskView?
    private var bottomIndicatorView : StickIndicatorView?
    private var graphView : GraphView?

    private var monthView : MonthHeaderView?
    private var weekView : WeekHeaderView?
    private var contentView : MonthContentView?
    private var leftIndicatorView : StickIndicatorView?
    private var rightIndicatorView : StickIndicatorView?
    
    private var graphDatas : [Double]?
    
    private var displayStatus = MonthDisplayStatus()
    
    var sourceView : DayCCell?
    
    var year : Int = 2018
    var month : Int = 11
    var dayEventWraps : [BillDayEventWrap]
    
    public init(with year : Int , month : Int) {
        
        self.year = year
        self.month = month
        self.dayEventWraps = [BillDayEventWrap]()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        self.containerView = UIView.init()
        containerView?.backgroundColor = .billWhite
        view.addSubview(self.containerView!)
        
        self.graphView = GraphView.init(with: self as ScrollableGraphViewDataSource)
        view.addSubview(self.graphView!)
        
        self.snapshotView = UIImageView.init()
        snapshotView?.contentMode = .scaleAspectFit
        snapshotView?.isHidden = true
        view.addSubview(self.snapshotView!)
        
        self.monthMaskView = MonthMaskView.init(frame: .zero)
        self.monthMaskView?.alpha = 0.0
        self.monthMaskView?.tapAction = {
            self.resetView()
        }
        view.addSubview(self.monthMaskView!)
        
        self.bottomIndicatorView = StickIndicatorView.init(with: .top)
        bottomIndicatorView?.config(with: "上拉返回首页")
        bottomIndicatorView?.configFull(with: "松手返回")
        view.addSubview(bottomIndicatorView!)
        
        self.leftIndicatorView = StickIndicatorView.init(with: .left)
        leftIndicatorView?.config(with: "上一月")
        leftIndicatorView?.configFull(with: "松手切换")
        view.addSubview(leftIndicatorView!)
        
        self.rightIndicatorView = StickIndicatorView.init(with: .right)
        rightIndicatorView?.config(with: "下一月")
        rightIndicatorView?.configFull(with: "松手切换")
        view.addSubview(rightIndicatorView!)
        
        self.monthView = MonthHeaderView.init(frame: .zero)
        containerView!.addSubview(self.monthView!)
        
        self.weekView = WeekHeaderView.init(frame: .zero)
        containerView!.addSubview(self.weekView!)
        
        self.contentView = MonthContentView.init(frame: .zero)
        self.contentView?.delegate = self
        containerView!.addSubview(self.contentView!)
        
        self.onLoadCurrentMonthEventWraps()
        
        let directionGesture = DirectionGestureRecognizer.init(target: self, action: #selector(self.onDirectionGestureAction))
        directionGesture.delegate = self
        view.addGestureRecognizer(directionGesture)
        
        containerView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        graphView!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(250)
            make.bottom.equalTo(self.snapshotView!.snp.top)
        }

        snapshotView!.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(containerView!)
        }
        
        monthMaskView!.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(snapshotView!.snp.top).offset(UIDevice.current.statusBarHeight() + 76)
        }
        
        bottomIndicatorView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(60)
            make.top.equalTo(snapshotView!.snp.bottom)
        })
        
        monthView!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(76)
            make.top.equalTo(containerView!.safeAreaLayoutGuide)
        }
        weekView!.snp.makeConstraints { (make) in
            make.left.equalTo(monthView!).offset(7.0)
            make.right.equalTo(monthView!).offset(-7.0)
            make.height.equalTo(60)
            make.top.equalTo(monthView!.snp.bottom)
        }
        contentView!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(weekView!.snp.bottom).offset(0)
            make.bottom.equalTo(containerView!.safeAreaLayoutGuide).offset(-20)
        }
        leftIndicatorView?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(snapshotView!)
            make.size.equalTo(CGSize.init(width: 60, height: 200))
            make.right.equalTo(snapshotView!.snp.left)
        })
        rightIndicatorView?.snp.makeConstraints({ (make) in
            make.size.equalTo(leftIndicatorView!)
            make.left.equalTo(snapshotView!.snp.right)
            make.centerY.equalTo(leftIndicatorView!)
        })
        // Do any additional setup after loading the view.
    }
    
    @objc override func onEventChange() {
        
        self.onLoadCurrentMonthEventWraps()
    }
    
    private func onLoadCurrentMonthEventWraps() {
        
        self._loadEventWraps(at : self.month)
    }
    
    private func onLoadPreMonthEventWraps() {
        
        month -= 1
        if month != 0 {
            print("加载前一个月，加载指示器显示 上一个月")
            self._loadEventWraps(at : month)
        }else{
            print("今年的已经查询完毕，加载指示器隐藏")
        }
    }
    
    private func onLoadNextMonthEventWraps() {
        
        month += 1
        if month <= 12 {
            print("加载下一个月，加载指示器显示 下一个月")
            self._loadEventWraps(at : month)
        }else{
            print("今年的已经查询完毕，加载指示器隐藏")
        }
    }
    
    private func _loadEventWraps(at month : Int) {
        
        BillEventKitSupport.support.complementedBillEventForMonth(year: self.year, month: month) { (merge) in
            
            let current = merge.currentMonthEventWrap
            
            self.dayEventWraps = merge.merge
            self.graphDatas = merge.currentMonthEventWrap.dayEventWraps.map({ (eventWrap) -> Double in
                return eventWrap.totalBill
            })
            
            self.monthView?.monthLabel?.text = String.monthString(month)
            self.monthView?.setupMoney("\(current.totalBill)".billMoneyFormatter)
            self.contentView!.updateData(with: self.dayEventWraps,
                                        at: self.year,
                                        month: month)
            self.graphView?.reload()
        }
    }
    
    @objc func onDirectionGestureAction(_ gesture : DirectionGestureRecognizer) {
        
        if gesture.state == .began {
            
            var image = UIImage()
            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0);
            //获取图像
            view.layer.render(in: UIGraphicsGetCurrentContext()!)
            image = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext();
            self.snapshotView?.image = image
            self.snapshotView?.isHidden = false
            
            self.containerView?.isHidden = true
        }
        if (gesture.state == .changed) {
            
            let offset = gesture.offset;
            if (gesture.direction == .up) {
                self.upToDisplayDismissView(with: Double(offset))
            }
            if (gesture.direction == .down) {
                self.downToDisplayCharts(with: Double(offset))
            }
            if (gesture.direction == .left) {
                self.leftToDisplayNextMonth(with : Double(offset))
            }
            if (gesture.direction == .right) {
                self.rightToDisplayPreMonth(with : Double(offset))
            }
        }else if(gesture.state == .ended ||
            gesture.state == .failed){
            
            if self.displayStatus.canChangeDisplay {
                if self.displayStatus.displayView == .graphView {
                    self.displayGraphView()
                }
                if self.displayStatus.displayView == .dismissView {
                    self.navigationController?.popViewController(animated: true)
                }
                if self.displayStatus.displayView == .nextView {
                    print("展示下一个月的视图")
                    self.displayNextMonthView()
                }
                if self.displayStatus.displayView == .preView {
                    print("展示前一个月的视图")
                    self.displayPreMonthView()
                }
            } else {
                self.resetView()
            }
        }
    }
    
    private func springAnimator() -> UIViewPropertyAnimator {
        
        var timingParameters = UISpringTimingParameters.init(dampingRatio: 0.025,
                                                             initialVelocity: CGVector.init(dx: 0.1, dy: 0.3))
        timingParameters = UISpringTimingParameters.init(mass: 3,
                                                         stiffness: 320,
                                                         damping: 32,
                                                         initialVelocity: CGVector.init(dx: 0.3, dy: 0.3))
        return UIViewPropertyAnimator.init(duration: 0.55, timingParameters: timingParameters)
    }
}

extension MonthViewController {
    
    private func leftToDisplayNextMonth(with offset : Double) {
        
        let forbidChange = self.month == 12
        
        self.rightIndicatorView?.isHidden = forbidChange
        self.rightIndicatorView?.update(with: CGFloat(abs(offset)/80.0))
        
        if !forbidChange {
            self.displayStatus.displayView = .nextView
            self.displayStatus.canChangeDisplay = abs(offset) >= 80
        }
        
        self.modifSnapshotViewHorizon(with: offset)
    }
    
    private func rightToDisplayPreMonth(with offset : Double) {
        
        let forbidChange = self.month == 1
        
        self.leftIndicatorView?.isHidden = forbidChange
        self.leftIndicatorView?.update(with: CGFloat(abs(offset)/80.0))
        
        if !forbidChange {
            self.displayStatus.displayView = .preView
            self.displayStatus.canChangeDisplay = abs(offset) >= 80
        }
        
        self.modifSnapshotViewHorizon(with: offset)
    }
    
    private func modifSnapshotViewHorizon(with offset : Double) {
        self.snapshotView!.snp.updateConstraints({ (make) in
            make.left.equalToSuperview().offset(offset)
        })
        self.view.layoutIfNeeded()
    }
    
    private func displayPreMonthView() {
        
        self.leftIndicatorView?.isHidden = true
        self.view.isUserInteractionEnabled = false

        self.onLoadPreMonthEventWraps()
        self.containerView?.isHidden = false
        self.containerView?.transform = CGAffineTransform.init(translationX: -self.view.frame.width,
                                                               y: 0)
        let animator = self.springAnimator()
        animator.addAnimations {
            self.modifSnapshotViewHorizon(with: Double(self.view.frame.width))
            self.containerView?.transform = .identity
        }
        animator.addCompletion { (_) in
            self.view.isUserInteractionEnabled = true
            self.snapshotView?.isHidden = true
            self.modifSnapshotViewHorizon(with: 0)
            self.displayStatus.reset()
        }
        animator.startAnimation()
    }
    
    private func displayNextMonthView() {
        
        self.rightIndicatorView?.isHidden = true
        self.view.isUserInteractionEnabled = false
        
        self.onLoadNextMonthEventWraps()
        self.containerView?.isHidden = false
        self.containerView?.transform = CGAffineTransform.init(translationX: self.view.frame.width,
                                                               y: 0)
        
        let animator = self.springAnimator()
        animator.addAnimations {
            self.modifSnapshotViewHorizon(with: -Double(self.view.frame.width))
            self.containerView?.transform = .identity
        }
        animator.addCompletion { (_) in
            self.view.isUserInteractionEnabled = true
            self.snapshotView?.isHidden = true
            self.modifSnapshotViewHorizon(with: 0)
            self.displayStatus.reset()
        }
        animator.startAnimation()
    }
}

extension MonthViewController {
    
    private func toDisplayGraphViewOffset() -> Double{
        return Double(self.graphView!.frame.height + 1 * (UIDevice.current.statusBarHeight()))
    }
    
    private func upToDisplayDismissView(with offset : Double) {
        
        self.bottomIndicatorView?.update(with: CGFloat(abs(offset)/120.0))
        self.bottomIndicatorView?.isHidden = false
        
        self.displayStatus.displayView = .dismissView
        self.displayStatus.canChangeDisplay = abs(offset) >= 120
        
        self.modifSnapshotViewVertical(with: offset)
    }
    
    private func downToDisplayCharts(with offset : Double) {
        
        self.displayStatus.displayView = .graphView
        self.displayStatus.canChangeDisplay = offset >= self.toDisplayGraphViewOffset()
        self.graphView?.alpha = CGFloat(abs(offset) / self.toDisplayGraphViewOffset())
        self.monthMaskView?.alpha = self.graphView!.alpha
        self.monthMaskView?.isUserInteractionEnabled = self.displayStatus.canChangeDisplay
        
        self.modifSnapshotViewVertical(with: offset)
    }
    
    private func displayGraphView() {
        
        let animator = self.springAnimator()
        animator.addAnimations {
            self.modifSnapshotViewVertical(with: self.toDisplayGraphViewOffset())
        }
        animator.startAnimation()
    }
    
    private func resetView() {
        
        view.isUserInteractionEnabled = false
        
        let animator = self.springAnimator()
        animator.addAnimations {
            self.modifSnapshotViewVertical(with: 0.0)
            self.modifSnapshotViewHorizon(with: 0.0)
            self.monthMaskView?.alpha = 0.0
            self.graphView?.alpha = 0.0
        }
        animator.addCompletion { (_) in
            self.view.isUserInteractionEnabled = true
            self.monthMaskView?.isUserInteractionEnabled = false
            self.displayStatus.reset()
            self.snapshotView?.isHidden = true
            self.containerView?.isHidden = false
        }
        animator.startAnimation()
    }
    
    private func modifSnapshotViewVertical(with offset : Double) {
        
        print("offset:\(offset)")
        
        self.snapshotView!.snp.updateConstraints({ (make) in
            make.top.equalToSuperview().offset(offset)
        })
        self.view.layoutIfNeeded()
    }
}

extension MonthViewController : UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if self.displayStatus.displayView == .graphView {
            return false
        }
//        return true
        let _view = gestureRecognizer.view
        let point : CGPoint = gestureRecognizer.location(in: _view)

        if !self.contentView!.frame.contains(point) {
            return true
        }
        
        let dayCells : [DayCCell] = contentView!.contentView.visibleCells as! [DayCCell]
        
        let canNotGestureRects = dayCells.filter { (cell) -> Bool in
            return cell.status != .invalid
            }.map { (cell) -> CGRect in
                return CGRect.init(x: cell.frame.minX,
                                   y: cell.frame.minY + self.contentView!.frame.minY,
                                   width: cell.frame.width,
                                   height: cell.frame.height)
            }
        
        if canNotGestureRects.count != 0 {
            
            for rect in canNotGestureRects {
                
                if rect.contains(point){
                    return false
                }
            }
        }
        
        return true
    }
}

extension MonthViewController : MonthContentViewDelegate{
    
    func monentContentViewDidSelected(at index: Int, cell: UIView) {
        
        self.sourceView = cell as? DayCCell
        
        let day = DayViewController.init(with: self.dayEventWraps[index])
        day.transitioningDelegate  = self
        day.modalPresentationStyle = .custom
        self.present(day, animated: true, completion: nil)
    }
}

extension MonthViewController : ScrollableGraphViewDataSource {

    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        if plot.identifier == "bill" || plot.identifier == "money" {
            if let graphDatas = self.graphDatas {
                if pointIndex < graphDatas.count {
                    return graphDatas[pointIndex]
                }
            }
        }
        return 0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(pointIndex + 1)"
    }
    func numberOfPoints() -> Int {
        let date = Calendar.current.dateWith(year: self.year, month: self.month, day: 1)
        return Calendar.current.totalDaysOfMonth(for: date)
    }
}

extension MonthViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented.isKind(of: DayViewController.self) {
            let present = BillDayPresentAnimator()
            present.delegate = self
            return present
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed.isKind(of: DayViewController.self) {
            return BillDayDismissAnimator()
        }
        return nil
    }
}

