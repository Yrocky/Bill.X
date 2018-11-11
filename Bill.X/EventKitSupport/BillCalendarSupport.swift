//
//  BillCalendarSupport.swift
//  Bill.X
//
//  Created by Rocky Young on 2018/11/11.
//  Copyright © 2018 meme-rocky. All rights reserved.
//

import Foundation

extension Date {
    ///当前日期的日
    public var day : Int {
        get{
            return Calendar.current.dateComponents([.year,.month,.day], from: Date()).day ?? 0
        }
    }
    
    ///当前日期的月份
    public var month : Int {
        get{
            return Calendar.current.dateComponents([.year,.month,.day], from: Date()).month ?? 0
        }
    }
    
    ///当前日期的年份
    public var year : Int {
        get{
            return Calendar.current.dateComponents([.year,.month,.day], from: Date()).year ?? 0
        }
    }
}
extension Calendar{
    
    ///本周的第一天
    public func startOfWeek(for date : Date) -> Date {

        return self.dateIntervalOfWeekend(containing: date)?.start ?? date
    }
    
    ///下周的第一天
    public func nextStartOfWeek(for date : Date) -> Date {
        var comps = DateComponents.init()
        comps.day = 7
        let next = self.date(byAdding: comps, to: date)
        return self.startOfWeek(for:next ?? date)
    }
    
    ///本月的第一天
    public func startOfMonth(for date : Date) -> Date {

        return self.dateInterval(of: .month, for: date)?.start ?? date
    }
    
    ///传入的日期是周几 1-7
    public func weekDay(for date : Date) -> Int {
        
        return 2
    }
    
    ///当前日期月份有多少天
    public func totalDaysOfMonth(for date : Date) -> Int {
//        self.
        return 31
    }
    
    ///传入年份的第一天和最后一天
    public func startAndLastDay(of date : Date , component : Component) -> (start : Date, last : Date) {
        var comps = DateComponents()
        comps.year = date.year
        comps.month = date.month
        comps.day = date.day
        
        let dateInterval = self.dateInterval(of: component, for: date)
        return (dateInterval?.start ?? Date() , dateInterval?.end ?? Date())
    }
    
    ///传入年份的第一天和最后一天
    public func startAndLastDay(of year : Int) -> (start : Date, last : Date) {
        var comps = DateComponents()
        comps.year = year
        comps.month = 2
        comps.day = 2
        let date = self.date(from: comps)
        
        return self.startAndLastDay(of: date!, component: .year)
    }
    
    public func startAndLastDay(of year : Int , and month : Int) -> (start : Date , last : Date) {
        
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 2
        let date = self.date(from: comps)
        
        return self.startAndLastDay(of: date! , component: .month)
    }
}
