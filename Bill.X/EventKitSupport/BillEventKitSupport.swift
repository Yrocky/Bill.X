//
//  BillEventKitSupport.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/11.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import UIKit
import EventKit

class BillEventKitSupport: NSObject {
    
    typealias EventKitSupportCompletionBlock = (_ scuess: Bool) -> Void
    typealias EventKitSupportFetchResultBlock = (_ events: [BillEventWrap]) -> Void
    
    ///<单例模式
    static let support = BillEventKitSupport()
    
    private(set) var eventStore : EKEventStore
    private(set) var accessGrand : Bool = false
    private(set) var calendar : EKCalendar?
    
    override func copy() -> Any {
        return BillEventKitSupport.support
    }
    
    override func mutableCopy() -> Any {
        return BillEventKitSupport.support
    }
    
    override init() {
        self.eventStore = EKEventStore()
        super.init()
        self.checkEventStoreAccessForCanendar { (accessGrand) in
            if accessGrand && self.calendar == nil {
                self.calendar = self.createCalendarIfNeeded()
            }
        }
    }
    
    func checkEventStoreAccessForCanendar(_ completion : @escaping EventKitSupportCompletionBlock) {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .authorized:///已经授权
            self.accessGrand = true
            completion(true)
        case .notDetermined:///没有授权过
            self.requestCalendarEventAccess(completion)
        case .denied,.restricted:///拒绝授权
            self.requestCalendarEventAccess(completion)
        }
    }
    
    private func createCalendarIfNeeded() -> EKCalendar {
        
        var source : EKSource?
        var calendar : EKCalendar?
        var neededCreateCalendar = true
        
        ///获取自定义的event日历
        for _calendar in self.eventStore.calendars(for: EKEntityType.event){
            if _calendar.title == "Bill.X" && _calendar.type == .calDAV{
                neededCreateCalendar = false
                calendar = _calendar
                break
            }
        }
        
        if neededCreateCalendar {
            ///获取event所在的iCloud源
            for _source in self.eventStore.sources {
                if _source.sourceType == .calDAV && _source.title == "iCloud" {
                    source = _source
                    break
                }
            }
            if source == nil {
                for _source in self.eventStore.sources {
                    if _source.sourceType == .local {///模拟器中没有iCloud
                        source = _source
                        break
                    }
                }
            }
            calendar = EKCalendar.init(for: .event, eventStore: self.eventStore)
            calendar!.source = source!
            calendar!.title = "Bill.X"
            calendar!.cgColor = UIColor.billBlue.cgColor
            do {
                try self.eventStore.saveCalendar(calendar!, commit: true)
            } catch {
                print("Error - Create calendar failed")
            }
            
        }
        return calendar!
    }
    
    private func requestCalendarEventAccess(_ completion : @escaping EventKitSupportCompletionBlock) {
        
        self.eventStore.requestAccess(to: .event) { (granted, error) in
            
            DispatchQueue.main.async {
                self.accessGrand = granted
                completion(granted)
            }
        }
    }
}

///<CRUD
extension BillEventKitSupport {
    
    ///<添加一个event
    public func addBillEvent(_ eventWrap : BillEventWrap , _ completion : EventKitSupportCompletionBlock) {
        
        guard accessGrand else {
            completion(false)
            return
        }
        
        do {
            eventWrap.calendar(self.calendar!)
            
            try self.eventStore.save(eventWrap.event, span: .thisEvent, commit:true)
            completion(true)
            print("Success - Save event done : \(eventWrap.description)")
        } catch  {
            print("Error - Could not save event :\(error.localizedDescription)")
            completion(false)
        }
    }
    
    ///<查询所有的event
    public func fetchBillEventAll(_ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        
        let start = Calendar.current.dateWith(year: Date().year - 3, month: 1, day: 1)
        let last = Date()
        
        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
        }
    }
    
    ///<查询 2017 年的event
    public func fetchBillEvent(year : Int , _ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        
        let (start,last) = Calendar.current.startAndLastDay(of: year)
        
        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
        }
    }
    
    ///<查询 2017-10 月的event
    public func fetchBillEvent(year : Int ,month : Int , _ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        
        let (start,last) = Calendar.current.startAndLastDay(of: year, and: month)
        
        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
        }
    }
    
    ///<查询 2017-10-8 日的event
    public func fetchBillEvent(year : Int ,month : Int ,day : Int , _ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        
        let start = Calendar.current.dateWith(year: year, month: month, day: day)
        let last = Date()
        
        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
        }
    }
    
    ///<删除一个event
    public func removeBillEvent(_ eventWrap : BillEventWrap , _ completion : EventKitSupportCompletionBlock) {
        
        guard accessGrand else {
            completion(false)
            return
        }
        
        do {
            try self.eventStore.remove(eventWrap.event, span: .thisEvent, commit: true)
            completion(true)
            print("Success - Remove event done : \(eventWrap.description)")
        } catch  {
            print("Error - Could not remove event :\(error.localizedDescription)")
            completion(false)
        }
    }
    
    ///<更新一个event
    public func updateBillEvent(_ eventWrap : BillEventWrap , _ completion : EventKitSupportCompletionBlock) {
        
        guard accessGrand else {
            completion(false)
            return
        }
        
        do {
            try self.eventStore.save(eventWrap.event, span: .thisEvent, commit: true)
            completion(true)
            print("Success - Update event done : \(eventWrap.description)")
        } catch  {
            print("Error - Could not update event :\(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func asyncFetchBillEventAt(range : (start: Date,last : Date) , _ result : @escaping EventKitSupportFetchResultBlock) {
        
        DispatchQueue.global().async {
            
            let predicate = self.eventStore.predicateForEvents(withStart: range.start, end: range.last, calendars: [self.calendar!])
            
            let eventWraps = self.eventStore.events(matching: predicate).map({ (event) -> BillEventWrap in
                return BillEventWrap.init(with: event)
            })
            DispatchQueue.main.async {
                result(eventWraps)
            }
        }
    }
}

///< BillEventWrap相关api
extension BillEventKitSupport {
    
    ///<将某一年的event按照月份进行分类
    func arrangeBillEventForYear(_ eventWraps : [BillEventWrap]) -> [[BillEventWrap]] {
        
        guard eventWraps.count != 0 else {
            return []
        }
        
        var monthEventWraps = [[BillEventWrap]]()
        
        for index in 1...12 {
            
            var oneMonthEventWraps = [BillEventWrap]()
            
            eventWraps.forEach { (eventWrap) in
                if eventWrap.date.month == index {
                    oneMonthEventWraps.append(eventWrap)
                }
            }
            
            monthEventWraps.append(oneMonthEventWraps)
        }
        return monthEventWraps
    }
    
//    ///<将某一年的event按照月份进行分类
//    func arrangeBillEventForYear(_ eventWraps : [BillEventWrap]) -> BillYearEventWrap {
//
//        guard eventWraps.count != 0 else {
//            return BillYearEventWrap()
//        }
//        var yearEventWrap = BillYearEventWrap()
//
//        for index in 1...12 {
//
//            var monthEventWrap = BillMonthEventWrap()
//
//            eventWraps.forEach { (eventWrap) in
//                if eventWrap.date.month == index {
//                    var dayEventWrap = BillDayEventWrap()
//
//                    monthEventWrap.dayEventWraps.append(dayEventWrap)
//                }
//            }
//            yearEventWrap.monthEventWraps.append(monthEventWrap)
////            monthEventWraps.append(oneMonthEventWraps)
//        }
//        return yearEventWrap
//    }

    
    ///<将某一月的event按照天进行分类
    func arrangeBillEventForMonth(_ eventWraps : [BillEventWrap] , year : Int , month : Int) -> BillMonthEventWrap {
        
        guard eventWraps.count != 0 else {
            return BillMonthEventWrap()
        }
        
        var monthEventWrap = BillMonthEventWrap()
        monthEventWrap.year = year
        monthEventWrap.month = month
        let monthDayCount = Calendar.current.totalDaysOfMonth(for: year, month: month)
        
        for index in 1...monthDayCount {

            var dayEventWrap = BillDayEventWrap(with: eventWraps.filter { (eventWrap) -> Bool in
                return eventWrap.date.day == index
            })
            dayEventWrap.year = year
            dayEventWrap.month = month
            dayEventWrap.day = index
            monthEventWrap.dayEventWraps.append(dayEventWrap)
        }
        
        return monthEventWrap
    }
}
