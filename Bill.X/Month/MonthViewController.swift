//
//  MonthViewController.swift
//  Bill.X
//
//  Created by meme-rocky on 2018/11/6.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import ScrollableGraphView

class MonthViewController: BillViewController{

    private var monthView : MonthHeaderView?
    private var weekView : WeekHeaderView?
    private var contentView : MonthContentView?
    private var graphView : ScrollableGraphView?
    private var graphDatas : [Double]?
    
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

        self.monthView = MonthHeaderView.init(frame: .zero)
        self.weekView = WeekHeaderView.init(frame: .zero)
        
        self.contentView = MonthContentView.init(frame: .zero)
        self.contentView?.delegate = self
        
        view.addSubview(self.monthView!)
        view.addSubview(self.weekView!)
        view.addSubview(self.contentView!)
        
        let frame = CGRect.init(x: 0, y: 100, width: view.frame.width, height: 200)
        let graphView = ScrollableGraphView(frame: frame, dataSource: self)
        graphView.backgroundFillColor = .white
        graphView.rangeMin = 0
        graphView.rangeMax = 90
        graphView.dataPointSpacing = 40
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        let linePlot = LinePlot(identifier: "bill")
        linePlot.lineWidth = 2
        linePlot.animationDuration = 1.25
        linePlot.lineColor = .billBlue
        linePlot.lineStyle = .smooth
        linePlot.shouldFill = true
        linePlot.fillType = .gradient
        linePlot.fillGradientType = .radial
        linePlot.fillGradientStartColor = .billBlue
        linePlot.fillGradientEndColor = UIColor.billBlue.withAlphaComponent(0)
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView.addPlot(plot: linePlot)
        
        let dotPlot = DotPlot(identifier: "money")
        dotPlot.dataPointType = .circle
        dotPlot.animationDuration = 1.25
        dotPlot.dataPointSize = 4
        dotPlot.dataPointFillColor = .billBlueHighlight
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView.addPlot(plot: dotPlot)

        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .billDINBold(12)
        referenceLines.referenceLineLabelColor = .billOrange
        referenceLines.dataPointLabelColor = .billBlack
        referenceLines.dataPointLabelFont = .billPingFang(12, weight: .light)
        referenceLines.positionType = .absolute
        referenceLines.dataPointLabelsSparsity = 3
        referenceLines.absolutePositions = [35, 55, 100]// 35工作日一天，55周末1天，100特殊情况一天
        referenceLines.dataPointLabelBottomMargin = 10
//        referenceLines.includeMinMax = false
        graphView.addReferenceLines(referenceLines: referenceLines)
        
        view.addSubview(graphView)
        
        self.onLoadCurrentMonthEventWraps()
        
        let directionGesture = DirectionGestureRecognizer.init(target: self, action: #selector(self.onDirectionGestureAction))
        directionGesture.delegate = self
//        view.addGestureRecognizer(directionGesture)
        
        monthView!.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(76)
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
        weekView!.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(7.0)
            make.right.equalToSuperview().offset(-7.0)
            make.height.equalTo(60)
            make.top.equalTo(monthView!.snp.bottom)
        }
        contentView!.snp.makeConstraints { (make) in
            make.left.right.equalTo(view)
            make.top.equalTo(weekView!.snp.bottom).offset(0)
            make.bottom.equalTo(bottomLayoutGuide.snp.top).offset(-20)
        }
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
            self.monthView!.totalLabel.text = "￥\(current.totalBill)".billMoneyFormatter
            self.contentView!.updateData(with: self.dayEventWraps,
                                        at: self.year,
                                        month: month)
            self.graphView?.reload()
        }
    }
    
    @objc func onDirectionGestureAction(_ gesture : DirectionGestureRecognizer) {
        
        if (gesture.state == .changed) {
            
            var offset = gesture.offset;
            offset = offset > 0 ? pow(offset, 0.7) : -pow(-offset, 0.7);

            if (gesture.direction == .up) {
                self.contentView!.transform = CGAffineTransform.init(translationX: 0, y: offset)
            }
            if (gesture.direction == .down) {
                self.contentView!.transform = CGAffineTransform.init(translationX: 0, y: offset)
            }
            if (gesture.direction == .left) {
                self.contentView!.transform = CGAffineTransform.init(translationX: offset, y: 0)
            }
            if (gesture.direction == .right) {
                self.contentView!.transform = CGAffineTransform.init(translationX: offset, y: 0)
            }
        }else if(gesture.state == .ended ||
            gesture.state == .failed){
            
            let timingParameters = UISpringTimingParameters.init(dampingRatio: 0.125, initialVelocity: CGVector.init(dx: 0.3, dy: 0.3))
            let animator = UIViewPropertyAnimator.init(duration: 0.25, timingParameters: timingParameters)
            animator.addAnimations {
                self.contentView!.transform = .identity
            }
            animator.startAnimation()
        }
    }
}

extension MonthViewController : UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
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
    
    func monentContentViewDidSelected(at index: Int) {
        
        let day = DayViewController.init(with: self.dayEventWraps[index])
        navigationController?.pushViewController(day, animated: true)
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
