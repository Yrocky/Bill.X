//
//  MonthMaskView.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/20.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import ScrollableGraphView

class GradientView: UIView {
    
    public var gradientLayer : CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer = self.layer as? CAGradientLayer
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1)
        gradientLayer.colors = [UIColor.billWhite.withAlphaComponent(0.2).cgColor,
                                UIColor.billWhite.cgColor]
        gradientLayer.locations = [NSNumber.init(value: 0.2),
                                   NSNumber.init(value: 0.7)]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}

class MonthMaskView: GradientView {

    var tapAction : (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.onTap))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap() {
        if let action = self.tapAction {
            action()
        }
    }
}

class GraphView: GradientView {
    
    private var graphView : ScrollableGraphView?
    
    public init(with dataSource : ScrollableGraphViewDataSource) {
        graphView = ScrollableGraphView(frame: .zero, dataSource: dataSource)
        super.init(frame: .zero)
        self.gradientLayer.colors = [UIColor.white.cgColor,
                                     UIColor.billWhite.cgColor]
        
        graphView?.backgroundFillColor = .clear
        graphView?.showsHorizontalScrollIndicator = false
        graphView?.rangeMin = 0
        graphView?.rangeMax = 90
        graphView?.dataPointSpacing = 40
        graphView?.shouldAdaptRange = true
        graphView?.shouldRangeAlwaysStartAtZero = true
        
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
        graphView?.addPlot(plot: linePlot)
        
        let dotPlot = DotPlot(identifier: "money")
        dotPlot.dataPointType = .circle
        dotPlot.animationDuration = 1.25
        dotPlot.dataPointSize = 4
        dotPlot.dataPointFillColor = .billBlueHighlight
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        graphView?.addPlot(plot: dotPlot)
        
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = .billDINBold(12)
        referenceLines.referenceLineLabelColor = .billOrange
        referenceLines.referenceLineColor = .billGray
        referenceLines.dataPointLabelColor = .billBlack
        referenceLines.dataPointLabelFont = .billPingFang(12, weight: .light)
        referenceLines.positionType = .absolute
        referenceLines.dataPointLabelsSparsity = 3
        referenceLines.absolutePositions = [35, 55, 100]// 35工作日一天，55周末1天，100特殊情况一天
        referenceLines.dataPointLabelBottomMargin = 10
        referenceLines.referenceLinePosition = ScrollableGraphViewReferenceLinePosition.both
        graphView?.addReferenceLines(referenceLines: referenceLines)
        addSubview(graphView!)
        
        graphView?.snp.makeConstraints({ (make) in
            make.left.top.right.bottom.equalToSuperview()
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func reload() {
        self.graphView?.reload()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
