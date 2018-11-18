//
//  BillEventWrap.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/11.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import EventKit

class BillEventWrap: NSObject {

    private(set) var event : EKEvent
    
    var money : Double? = 0.0
    var usage : String? = ""
    var notes : String? = ""
    var date : Date = Date()
    
    ///创建一个新的event，使用wrap来表示
    public static func eventWrap(with eventStoreSupport: BillEventKitSupport ,
                                 money : Double? ,
                                 usage : String?) -> BillEventWrap{
        
        var comps = DateComponents()///<for debug
        comps.year = 2017
        comps.month = 10
        comps.day = 23
        let date = Date()//Calendar.current.date(from: comps)
        
        let event = EKEvent.init(eventStore: eventStoreSupport.eventStore)
        if let usage = usage , let money = money {
            event.title = "\(usage):\(money)"
            event.notes = "\(usage) 花费 \(money)元"
        }
        event.startDate = date
        event.endDate = event.startDate
        let eventWrap = BillEventWrap.init(with: event)
        return eventWrap
    }
    
    ///根据fetch结果中的event创建wrap
    init(with event : EKEvent) {
        
        self.event = event
        self.event.isAllDay = false
        if event.title != nil{
            let infos = event.title.components(separatedBy: ":")
            if infos.count == 2 {
                self.money = Double(infos.last!) ?? 0.0
                self.usage = infos.first!
            }
            self.notes = event.notes ?? ""
        }
        self.date = event.startDate == nil ? Date() : event.startDate
    }
    
    public func calendar(_ calendar : EKCalendar) {
        event.calendar = calendar
    }
    
    public func updateEvent() {
        
        if let usage = self.usage , let money = self.money {
            event.title = "\(usage):\(money)"
            if let notes = self.notes {
              event.notes = notes
            } else {
                event.notes = "\(usage) 花费 \(money)元"
            }
        }
        event.startDate = date
        event.endDate = event.startDate
    }
    
    override var debugDescription: String{
        get{
            return self.description
        }
    }
    
    override var description: String{
        get{
            return "\(self.date) \(self.money!) :" + event.title
        }
    }
}

struct BillDayEventWrap {
    
    var year : Int = 0
    var month : Int = 0
    var day : Int = 0
    
    var eventWraps : [BillEventWrap] = []
    
    var totalBill : Double {
        get{
            var sum = 0.0
            for eventWrap in eventWraps {
                sum += eventWrap.money!
            }
            return sum
        }
    }
    
    public init(with eventWraps : [BillEventWrap]) {
        self.eventWraps = eventWraps
        if eventWraps.count != 0 {
            let eventWrap = eventWraps.first
            self.year = eventWrap?.date.year ?? 0
            self.month = eventWrap?.date.month ?? 0
            self.day = eventWrap?.date.day ?? 0
        }
    }
}

struct BillMergeMonthEventWrap {
    
    var currentMonthEventWrap : BillMonthEventWrap
    
    var merge : [BillDayEventWrap]
    
    init(with currentMonthEventWrap : BillMonthEventWrap , merge : [BillDayEventWrap]) {
        self.currentMonthEventWrap = currentMonthEventWrap
        self.merge = merge
    }
}

struct BillMonthEventWrap {
    
    var year : Int = 0
    var month : Int = 0
    var dayEventWraps : [BillDayEventWrap] = []
    
    var totalBill : Double {
        get{
            var sum = 0.0
            for dayEventWrap in dayEventWraps {
                sum += dayEventWrap.totalBill
            }
            return sum
        }
    }
    
    var homeTotalBill : Double = 0.0
}

struct BillYearEventWrap {
    
    var year : Int = 0
    
    var monthEventWraps : [BillMonthEventWrap] = []
    
    var totalBill : Double {
        get{
            var sum = 0.0
            for monthEventWrap in monthEventWraps {
                sum += monthEventWrap.totalBill
            }
            return sum
        }
    }
}

