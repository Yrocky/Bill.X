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
    
    ///<用户获取月份下的event回调
    typealias EventKitSupportFetchMergeResultBlock = (_ merge: BillMergeMonthEventWrap) -> Void
    typealias EventKitSupportFetchYearResultBlock = (_ merge: BillYearEventWrap) -> Void
    
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
            eventWrap.updateEvent()
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
        let last = Date.init(timeInterval: 24*60*60, since: start)
        
        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
        }
    }
    
    ///<查询 指定日期之间 的event
    public func fetchBillEvent(from start : Date , to last : Date , _ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        
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
        
        eventWrap.updateEvent()
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

extension BillEventKitSupport {
    
    func complementedBillEventForYear(year : Int, _ result : @escaping EventKitSupportFetchYearResultBlock) {
        
        self.fetchBillEvent(year: year) { (eventWraps) in
            
            var yearEventWrap = BillYearEventWrap()
            
            var monthEventWraps = [BillMonthEventWrap]()
            for index in 1...12 {
                
                var monthEventWrap = BillMonthEventWrap()
                monthEventWrap.year = year
                monthEventWrap.month = index
                
                var sum : Double = 0.0
                for eventWrap in eventWraps {
                    if eventWrap.date.year == year &&
                        eventWrap.date.month == index {
                        sum += Double(eventWrap.money ?? 0)
                    }
                }
                monthEventWrap.homeTotalBill = sum
                monthEventWraps.append(monthEventWrap)
            }
            yearEventWrap.year = year
            yearEventWrap.monthEventWraps = monthEventWraps
            
            result(yearEventWrap)
        }
    }
}

extension BillEventKitSupport {
    
    func complementedBillEventForMonth(year : Int , month : Int , _ result : @escaping EventKitSupportFetchMergeResultBlock) {
        
        let calendar = Calendar.current
        
        let (firstDate,_) = calendar.startAndLastDay(of: year, and: month)
        let firstDayWeek = calendar.weekDay(for: firstDate)///<当前月份第一天是周几
        
        let currentMonthDayCount = calendar.totalDaysOfMonth(for: firstDate)///<当前月有多少天

        let preYear = month == 1 ? year - 1 : year
        let preMonth = month == 1 ? 12 : month - 1
        let preMonthDayCount = calendar.totalDaysOfMonth(for: calendar.dateWith(year: preYear, month: preMonth, day: 1))///<前一月有多少天
        let needPreMonthEventWrapCount = firstDayWeek == 0 ? 7 : firstDayWeek// 4
        
        let nextYear = month == 12 ? year + 1 : year
        let nextMonth = month == 12 ? 1 : month + 1
        let needNextMonthEventWrapCount = 42 - needPreMonthEventWrapCount - currentMonthDayCount
        
        let startDate = calendar.dateWith(year: preYear, month: preMonth, day: preMonthDayCount - needPreMonthEventWrapCount + 1)
        let endDate = calendar.dateWith(year: nextYear, month: nextMonth, day: needNextMonthEventWrapCount + 1)
        
        self.fetchBillEvent(from: startDate, to: endDate) { (eventWraps) in
            
            var dayEventWraps = [BillDayEventWrap]()
            
            // 前一个月
            for index in (preMonthDayCount - needPreMonthEventWrapCount + 1) ... preMonthDayCount {
                
                var dayEventWrap = BillDayEventWrap(with: eventWraps.filter { (eventWrap) -> Bool in
                    return eventWrap.date.day == index &&
                        eventWrap.date.month == preMonth &&
                    eventWrap.date.year == preYear
                })
                dayEventWrap.year = preYear
                dayEventWrap.month = preMonth
                dayEventWrap.day = index
                
                dayEventWraps.append(dayEventWrap)
            }
            
            // 当前月
            var currentMonthEventWrap = BillMonthEventWrap()
            currentMonthEventWrap.year = year
            currentMonthEventWrap.month = month
            
            for index in 1...currentMonthDayCount {
                
                var dayEventWrap = BillDayEventWrap(with: eventWraps.filter { (eventWrap) -> Bool in
                    return eventWrap.date.day == index && eventWrap.date.month == month
                })
                dayEventWrap.year = year
                dayEventWrap.month = month
                dayEventWrap.day = index
                
                currentMonthEventWrap.dayEventWraps.append(dayEventWrap)
                
                dayEventWraps.append(dayEventWrap)
            }
            
            // 下一个月
            for index in 1 ... needNextMonthEventWrapCount {
                
                var dayEventWrap = BillDayEventWrap(with: eventWraps.filter { (eventWrap) -> Bool in
                    return eventWrap.date.day == index &&
                        eventWrap.date.month == nextMonth &&
                        eventWrap.date.year == nextYear
                })
                dayEventWrap.year = nextYear
                dayEventWrap.month = nextMonth
                dayEventWrap.day = index
                
                dayEventWraps.append(dayEventWrap)
            }
            
            result(BillMergeMonthEventWrap.init(with: currentMonthEventWrap,
                                                merge: dayEventWraps))
        }

    }
}
