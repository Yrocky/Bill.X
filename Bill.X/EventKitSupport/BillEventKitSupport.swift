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
    
    private(set) var eventStore : EKEventStore
    private(set) var accessGrand : Bool = false
    private(set) var calendar : EKCalendar?
    
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
        case .authorized:
            self.accessGrand = true
            completion(true)
        case .notDetermined:///没有授权过
            self.requestCalendarEventAccess(completion)
        case .denied,.restricted:
            self.accessGrand = false
            completion(false)
        }
    }
    
    func saveBillEvent(_ eventWrap : BillEventWrap , _ completion : EventKitSupportCompletionBlock) {
        
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
    
    func fetchAllBillEvent(_ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        let (start,last) = Calendar.current.startAndLastDay(of: Date(),
                                                            component: .year)

        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
        }
    }
    
    func fetchBillEvent(year : Int , _ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        
        let (start,last) = Calendar.current.startAndLastDay(of: year)

        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
        }
    }
    
    func fetchBillEvent(month : Int , _ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        
        let (start,last) = Calendar.current.startAndLastDay(of: Date().year,
                                                            and: month)
        print(start)
        print(last)
        
        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
        }
    }
    
    func fetchBillEvent(day : Int , _ result : @escaping EventKitSupportFetchResultBlock) {
        
        guard accessGrand else {
            return
        }
        
        let (start,last) = Calendar.current.startAndLastDay(of: Date(), component: .year)
        
        self.asyncFetchBillEventAt(range: (start,last)) { (eventWraps) in
            result(eventWraps)
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
            if granted {
                DispatchQueue.main.async {
                    self.accessGrand = true
                    completion(true)
                }
            }
        }
    }
}
