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
    
    var notes : String = ""
    var money : Int = 0
    var usage : String = ""
    var date : Date = Date()
    
    ///创建一个新的event，使用wrap来表示
    public static func eventWrap(with eventStore: EKEventStore ,
                                 money : Int ,
                                 usage : String) -> BillEventWrap{
        
        var comps = DateComponents()
        comps.year = 2017
        comps.month = 10
        comps.day = 23
        let date = Calendar.current.date(from: comps)
        
        let event = EKEvent.init(eventStore: eventStore)
        event.title = "\(usage):\(money)"
        event.startDate = date
        event.endDate = event.startDate
        event.notes = "\(usage) 花费 \(money)元"
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
                self.money = Int(infos.last!) ?? 0
                self.usage = infos.first!
            }
            self.notes = event.notes ?? ""
        }
        self.date = event.startDate == nil ? Date() : event.startDate
    }
    
    public func calendar(_ calendar : EKCalendar) {
        event.calendar = calendar
    }
}
