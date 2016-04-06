//
//  HealthKitHelper.swift
//  StepCounter
//
//  Created by Guo Xiaoyu on 4/5/16.
//  Copyright © 2016 Xiaoyu Guo. All rights reserved.
//
// reference: https://swift.unicorn.tv/articles/step-counter-in-healthkit

import Foundation
import HealthKit

class HealthKitHelper {
    let storage = HKHealthStore()
    var count = 0
    var dates = [NSDate]()
    var steps = [Double]()
    var resDates = [NSDate]()
    
    init() {
        checkAuthorization()
    }
    
    func checkAuthorization() -> Bool {
        // Default to assuming that we're authorized
        var isEnabled = true
        
        // Do we have access to HealthKit on this device?
        if HKHealthStore.isHealthDataAvailable()
        {
            // We have to request each data type explicitly
            let steps = NSSet(object: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)!)
            
            // Now we can request authorization for step count data
            storage.requestAuthorizationToShareTypes(nil, readTypes: steps as? Set<HKObjectType>) { (success, error) -> Void in
                isEnabled = success
            }
        }
        else
        {
            isEnabled = false
        }
        
        return isEnabled
    }
    
    /// fetch steps from start date to end date, with one completion
    func fetchSteps(startDate: NSDate, endDate: NSDate, completion: (Double, NSError?) -> ()) {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Our search predicate which will fetch data from startDate to endDate
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Double = 0
            
            if results?.count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
            }
            
            completion(steps, error)
        }
        
        storage.executeQuery(query)
    }
    
    /// fetch steps from start date to end date, with two completion, used for 30 days
    func fetchSteps(startDate: NSDate, endDate: NSDate, completion: (NSDate, Double, NSError?, ([NSDate], [Double]) -> ()) -> (), allCompletion: (([NSDate], [Double]) -> ())?) {
        // The type of data we are requesting (this is redundant and could probably be an enumeration
        let type = HKSampleType.quantityTypeForIdentifier(HKQuantityTypeIdentifierStepCount)
        
        // Our search predicate which will fetch data from startDate to endDate
        let predicate = HKQuery.predicateForSamplesWithStartDate(startDate, endDate: endDate, options: .None)
        
        // The actual HealthKit Query which will fetch all of the steps and sub them up for us.
        let query = HKSampleQuery(sampleType: type!, predicate: predicate, limit: 0, sortDescriptors: nil) { query, results, error in
            var steps: Double = 0
            
            if results?.count > 0
            {
                for result in results as! [HKQuantitySample]
                {
                    steps += result.quantity.doubleValueForUnit(HKUnit.countUnit())
                }
            }
            
            completion(startDate, steps, error, allCompletion!)
        }
        
        storage.executeQuery(query)
    }
    
    /// get num of steps from midnight till now
    /// - parameter:
    /// - completion: what to do when get num of steps
    ///
    func getTodayNumOfSteps(completion: (Double, NSError?) -> ()) {
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startOfToday = cal.startOfDayForDate(date)
        fetchSteps(startOfToday, endDate: date, completion: completion)
    }
    
    /// get 29 days' steps
    /// - parameter:
    /// - allCompletion: what to do when all fetched
    func get29DaysNumOfSteps(allCompletion: ([NSDate], [Double]) -> ()) {
        count = 0
        steps = []
        resDates = []
        let dates = get29NSDate()
        for i in 0 ..< 29 {
            fetchSteps(dates[i], endDate: dates[i+1], completion: oneCompletion, allCompletion: allCompletion)
        }
    }
    
    /// helper func to get 29 nsdate
    func get29NSDate() -> [NSDate] {
        dates = []
        // get today's midnight's date
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let startOfToday = cal.startOfDayForDate(date)
        // first append
        dates.append(startOfToday)
        // rest 29 appends: -1, -2, ..., -29 days
        for i in 1 ..< 30 {
            let earlierDay = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -i, toDate: startOfToday, options: [])!
            dates.append(earlierDay)
        }
        dates = dates.reverse()
        return dates
    }
    
    /// one completion func, used for 29 day's step
    func oneCompletion(date: NSDate, numOfSteps: Double, error: NSError?, allCompletion: ([NSDate], [Double]) -> ()) {
        count += 1
        resDates.append(date)
        steps.append(numOfSteps)
        if count == 29 {
            count = 0
            allCompletion(resDates, steps)
        }
    }
    
}
