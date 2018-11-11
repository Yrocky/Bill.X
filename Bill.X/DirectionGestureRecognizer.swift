//
//  DirectionGestureRecognizer.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/10.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

enum GestureDirection {
    case up
    case down
    case left
    case right
    case unknow
}

class DirectionGestureRecognizer: UIGestureRecognizer {

    var hysteresisOffset : CGFloat = 2 ///<滞后的距离，默认为2
    private(set) var direction : GestureDirection = .unknow
    private(set) var offset : CGFloat = 0.0///<在当前方向上移动的距离

    private var startPoint : CGPoint = .zero
    
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
    }
    
    
    private func locationInHysteresisRange(_ location : CGPoint) -> Bool {
        
        let radius = self.hysteresisOffset;
        let dx = fabs(location.x - self.startPoint.x);
        let dy = fabs(location.y - self.startPoint.y);
        let dis = hypot(dx, dy);
        return dis <= radius;// 到startPoint的距离小于等于半径
    }
    
    private func startPointCenterGetDegree(with point : CGPoint) -> CGFloat{
        
        let center = self.startPoint;
        
        // 取出点击坐标x y
        let x = point.x;
        let y = point.y;
        
        // 圆心坐标
        let xC = center.x;
        let yC = center.y;
        
        // 计算控件距离圆心距离
        let distance = sqrt(pow((x - xC), 2) + pow(y - yC, 2));
        let xD = (x - xC);
        
        let mySin = fabs(xD) / distance;
        
        var degree : CGFloat = 0;
        if (point.x < center.x) {
            if (point.y < center.y) {
                degree = 360.0 - asin(mySin) / .pi * 180.0;
            }
            else{
                degree = asin(mySin) / .pi * 180.0 + 180.0;
            }
        }
        else{
            if (point.y < center.y) {
                degree = asin(mySin) / .pi * 180.0;
            }
            else{
                degree = 180.0 - asin(mySin) / .pi * 180.0;
            }
        }
        return degree;
    }
    
    private func gestureDirection(_ location : CGPoint) -> GestureDirection{
        
        let degree = self.startPointCenterGetDegree(with: location)
        
        if (degree <= 45.0 || degree > 315.0) {// up
            return .up;
        }else if(degree > 45.0 && degree <= 135.0){// right
            return .right;
        } else if (degree > 135.0 && degree <= 225.0){// down
            return .down;
        } else if (degree > 225.0 && degree <= 315.0){// left
            return .left;
        }
        return .unknow;
    }
    private func resetConfig() {
        
        self.startPoint = .zero;
        self.direction = .unknow
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event!)

        if (touches.count != 1) {// 仅支持一个手指的手势
            self.state = .failed;
        }
        self.startPoint = (touches.first?.location(in: self.view))!
        
        self.state = .began;
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event!)
        
        self.state = .cancelled;
        self.resetConfig()
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event!)
        
        self.state = .ended;
        self.resetConfig()
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event!)
        
        // 1 failed直接返回
        guard self.state != .failed else{
            return
        }
        
        // 2
        if (touches.count != 0) {
            let location = (touches.first?.location(in: self.view))!

            guard !self.locationInHysteresisRange(location) else{
                return
            }
            
            if (self.direction == .unknow) {// 还没有设置方向
                self.direction = self.gestureDirection(location)
                self.state = .changed;
            }
            if (self.direction == .up ||// 向上滑动
                self.direction == .down) {// 向下滑动
                self.offset = location.y - self.startPoint.y;
            }
            if (self.direction == .left ||// 向左移动
                self.direction == .right) {// 向右移动
                self.offset = location.x - self.startPoint.x;
            }
        }
    }
    override func reset() {
        super.reset()
        self.state = .possible
        self.resetConfig()
    }
}
