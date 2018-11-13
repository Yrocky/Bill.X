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
            return Calendar.current.dateComponents([.year,.month,.day], from: self).day ?? 0
        }
    }
    
    ///当前日期的月份
    public var month : Int {
        get{
            return Calendar.current.dateComponents([.year,.month,.day], from: self).month ?? 0
        }
    }
    
    ///当前日期的年份
    public var year : Int {
        get{
            return Calendar.current.dateComponents([.year,.month,.day], from: self).year ?? 0
        }
    }
}

extension Calendar{
    
    
    ///<给出的year-month-day是否是今天
    public func isToday(compareWith year : Int , month : Int , day : Int) -> Bool{
        
        let date = Calendar.current.dateWith(year: year, month: month, day: day)
        return self.isDate(date, inSameDayAs: Date())
    }
    
    public func isSameMonth(compare year : Int , month : Int , day : Int , with date : Date) -> Bool{
        
//        let dateInterval = self.dateInterval(of: .month, for: date)///<date日期所在的月份
//        let otherDate = self.dateWith(year: year, month: month, day: day)///<要比较的日期
//        print("compare is same month : \(otherDate) with \(date) ===> \(dateInterval)")
//        return dateInterval?.contains(otherDate) ?? false
        ///<用下面这个方法是因为上面会把下一个月的1号也算到当前月内
//        print("compare is same month : \(year)-\(month)-\(day) with \(date.year)-\(date.month)-\(date.day)")
        return date.year == year && date.month == month
    }
    
    public func isCurrentMonth(compareWith year : Int , month : Int , day : Int) -> Bool{
        
        return self.isSameMonth(compare: year, month: month, day: day, with: Date())
    }
    
    ///<创建一个Date对象
    public func dateWith(year : Int , month : Int , day : Int) -> Date{
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = day
        return self.date(from: comps) ?? Date()
    }
    
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
    
    ///传入的日期是周几 0-6 周日-周六
    public func weekDay(for date : Date) -> Int {
        
        let weekDay = self.component(Component.weekday, from: date) - 1
        return weekDay
    }
    
    ///当前日期月份有多少天
    public func totalDaysOfMonth(for date : Date) -> Int {
        return self.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    ///当前year-month下的月份有多少天
    public func totalDaysOfMonth(for year : Int , month : Int) -> Int {
        let date = self.dateWith(year: year, month: month, day: 1)
        return self.range(of: .day, in: .month, for: date)?.count ?? 0
    }
    
    ///传入date的今年第一天和最后一天
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
    
    ///<传入year month 下当月的第一天和最后一天
    public func startAndLastDay(of year : Int , and month : Int) -> (start : Date , last : Date) {
        
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 2
        let date = self.date(from: comps)
        
        return self.startAndLastDay(of: date! , component: .month)
    }
}
