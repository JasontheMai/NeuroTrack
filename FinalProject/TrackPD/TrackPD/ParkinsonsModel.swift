//
//  ParkinsonsModel.swift
//  Darrion Shack (dashack@iu.edu)
//  Jason Mai (jasmai@iu.edu)
//  NeuroTrack
//  Submission Date: 04/30/23

//
//  Created by Darrion Shack on 4/14/23.
//

import Foundation
import UIKit
import UserNotifications

class ParkinsonsModel {
    var averageTremors: [Int]
    var averageGait: [Int]
    var allReminders: [String]
    var gyroDataArray: [GyroData] = []
    var accelDataArray: [AccelData] = []
    var gaitDataArray: [GaitData] = []
    var lastGait: Double
    var tremorStandardDeviationOverTime: [TremorInstensity]
    var gaitStandardDeviationOverTime: [GaitOverTime]
    
    struct AccelData {
        var accelerationX: Double
        var accelerationY: Double
        var accelerationZ: Double
        var timestamp: Date
    }
    
    struct GyroData {
        var rotationRateX: Double
        var rotationRateY: Double
        var rotationRateZ: Double
        var timestamp: Date
    }
    
    struct GaitData {
        var stepCount: Int
        var distance: Double
        var strideLength: Double
        var timestamp: Date
    }

    
    
    init() {
        averageTremors = []
        averageGait = []
        allReminders = []
        tremorStandardDeviationOverTime = []
        gaitStandardDeviationOverTime = []
        lastGait = 0
        getData()
    }
    
    func saveData(){
                do {
                    let dataToSave = SavedData(gait: gaitStandardDeviationOverTime, tremor: tremorStandardDeviationOverTime, reminders: allReminders)
                    print(dataToSave.tremor.first ?? 0)
                    let manager = FileManager.default
                    let documentsurl = try manager.url(for:.documentDirectory, in:.userDomainMask, appropriateFor: nil, create: false)
                    let modelFile = documentsurl.appendingPathComponent("model.plist")
                    let modelPList = PropertyListEncoder()
                    modelPList.outputFormat = .xml
                    
                    try modelPList.encode(dataToSave).write(to: modelFile, options: .atomic)
                    
                } catch {
                    print(error)
                }
            }
            
            func getData(){
                do {
                    let manager = FileManager.default
                    let documentsurl = try manager.url(for:.documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                    let arrfile = documentsurl.appendingPathComponent("model.plist")
                    let arraydata = try Data(contentsOf: arrfile)
                    let dataArray = try PropertyListDecoder().decode(SavedData.self, from:arraydata)
                    allReminders = dataArray.reminders
                    tremorStandardDeviationOverTime = dataArray.tremor
                    gaitStandardDeviationOverTime = dataArray.gait
                    print(allReminders)
                    print(tremorStandardDeviationOverTime)
                    print(gaitStandardDeviationOverTime)
                }
                catch {
                    print(error)
                }
            }
    
    func getCurrentTremors() -> Double {
        calculateTremorIntensity()
        return tremorStandardDeviationOverTime.last?.standardDeviation ?? 0
    }
    
    func getCurrentGait() -> Double {
        if(self.gaitDataArray.count > 5) {
            calculateGaitChanges()
            lastGait = gaitStandardDeviationOverTime.last!.strideDeviation
            return gaitStandardDeviationOverTime.last!.strideDeviation
        } else {
            return lastGait
        }
    }
    
    func calculateByTimeFrame(timeFrame: Int, metric: String) -> Double {
            /*
             Uses the inputs to determine how to calculate the user's gait or tremors over the requested time period.
             returns the result
             end of function
             */
            if(metric == "tremor") {
                if(tremorStandardDeviationOverTime.count == 0) {
                    return 0
                }
                var i = tremorStandardDeviationOverTime.count - 1
                var count:Double = 0
                var tremor:Double = 0
                while(i >= 0) {
                    if(-(tremorStandardDeviationOverTime[i].timestamp.timeIntervalSinceNow) < Double(((60 * 60) * 24) * timeFrame)) {
                        if(tremorStandardDeviationOverTime[i].standardDeviation.isNaN && i != 0) {
                            tremorStandardDeviationOverTime.remove(at: i)
                            i -= 1
                        } else {
                            print(tremorStandardDeviationOverTime[i].timestamp.timeIntervalSinceNow)
                            print(tremor)
                            print(i)
                            tremor += tremorStandardDeviationOverTime[i].standardDeviation
                            i -= 1
                            count += 1
                        }
                    } else {
                        break
                    }
                }
                return tremor / count
            } else {
                if(gaitStandardDeviationOverTime.count == 0) {
                    return 0
                }
                var i = gaitStandardDeviationOverTime.count - 1
                var count:Double = 0
                var gait:Double = 0
                while(i >= 0) {
                    if(-(gaitStandardDeviationOverTime[i].timestamp.timeIntervalSinceNow) < Double(((60 * 60) * 24) * timeFrame)) {
                        if(gaitStandardDeviationOverTime[i].strideDeviation.isNaN && i != 0) {
                            gaitStandardDeviationOverTime.remove(at: i)
                            i -= 1
                        } else {
                            print(gaitStandardDeviationOverTime[i].timestamp.timeIntervalSinceNow)
                            print(gait)
                            print(i)
                            gait += gaitStandardDeviationOverTime[i].strideDeviation
                            i -= 1
                            count += 1
                        }
                    } else {
                        break
                    }
                }
                return gait / Double(i)
            }
        }
    
    
    func removeReminder(reminder: String) {
        var iter = 0
        while(iter != allReminders.count) {
            if(allReminders[iter] == reminder) {
                allReminders.remove(at: iter)
                break
            }
            iter += 1
        }
        if(allReminders.count == 0){
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    func addReminder(reminder: String) {
        allReminders.append(reminder)
        saveData()
        sendNotification()
    }
    
    func deleteReminders() {
        allReminders.removeAll()
        saveData()
    }
    
    func getReminder(position: Int) -> String {
        return allReminders[position]
    }
    
    func getReminderCount() -> Int {
        return self.allReminders.count
    }
    
    func addGyroData(rotationRateX: Double, rotationRateY: Double, rotationRateZ: Double, timestamp: Date) {
            let gyroData = GyroData(rotationRateX: rotationRateX, rotationRateY: rotationRateY, rotationRateZ: rotationRateZ, timestamp: timestamp)
            gyroDataArray.append(gyroData)
        }
    
    func addAccelData(accelerationX: Double, accelerationY: Double, accelerationZ: Double, timestamp: Date) {
            let accelData = AccelData(accelerationX: accelerationX, accelerationY: accelerationY, accelerationZ: accelerationZ, timestamp: timestamp)
            accelDataArray.append(accelData)
        }
    
    func addGaitData(stepCount: Int, distance: Double, strideLength: Double, timestamp: Date) {
        let newGaitData = GaitData(stepCount: stepCount, distance: distance, strideLength: strideLength, timestamp: timestamp)
            print("Test input:\n steps: \(stepCount)\n distance\(distance)\n stride length: \(strideLength)")
            gaitDataArray.append(newGaitData)
        }
    func calculateTremorIntensity(){
        if(!gyroDataArray.isEmpty && !accelDataArray.isEmpty) {
            var tremorIntensityArray: [Double] = []
            
            for i in 0..<gyroDataArray.count {
                let gyroData = gyroDataArray[i]
                let accelData = accelDataArray[i]
                
                let gyroIntensity = sqrt(pow(gyroData.rotationRateX, 2) + pow(gyroData.rotationRateY, 2) + pow(gyroData.rotationRateZ, 2))
                let accelIntensity = sqrt(pow(accelData.accelerationX, 2) + pow(accelData.accelerationY, 2) + pow(accelData.accelerationZ, 2))
                
                
                
                tremorIntensityArray.append(3 * gyroIntensity + accelIntensity)
            }
            var sum: Double = 0
            for intensity in tremorIntensityArray {
                sum += intensity
            }
            let mean = sum / Double(tremorIntensityArray.count)
            
            
            
            var varianceSum = 0.0
            for value in tremorIntensityArray {
                varianceSum += pow(value - mean, 2)
            }
            
            var variance = varianceSum / Double(tremorIntensityArray.count - 1)
            
            let calculatedData = TremorInstensity(standardDeviation: variance, timestamp: gyroDataArray[0].timestamp)
            tremorStandardDeviationOverTime.append(calculatedData)
            gyroDataArray.removeAll()
            accelDataArray.removeAll()
        } else {
            tremorStandardDeviationOverTime.append(TremorInstensity(standardDeviation: 0, timestamp: Date()))
        }
        saveData()
       }
       
    

    


    func calculateGaitChanges(){
        var stepsProcessingArray: [Double] = []
        var strideProcessingArray: [Double] = []
        for i in 0..<gaitDataArray.count {
            let data = gaitDataArray[i]
            
            let stepsPerDistance = Double(data.stepCount) / data.distance
            let stridePerDistance = data.strideLength / data.distance
            stepsProcessingArray.append(stepsPerDistance)
            strideProcessingArray.append(stridePerDistance)
            
        }
     var stepSum: Double = 0
         for steps in stepsProcessingArray {
             stepSum += steps
         }
         let stepsMean = stepSum / Double(stepsProcessingArray.count)
     
        var strideSum: Double = 0
        for stride in strideProcessingArray{
            strideSum += stride
        }
        let strideMean = strideSum / Double(strideProcessingArray.count)
        
        var strideVarianceSum = 0.0
        for value in strideProcessingArray{
            strideVarianceSum += pow(value - strideMean, 2)
        }
        var strideVariance = strideVarianceSum / Double(strideProcessingArray.count - 1)
        strideVariance = strideVariance / strideMean
        
        var stepVarianceSum = 0.0
        for value in stepsProcessingArray {
            stepVarianceSum += pow(value - stepsMean, 2)
        }
        
     var stepVariance = stepVarianceSum / Double(stepsProcessingArray.count - 1)
        

        
        
        
     
     let calculatedData = GaitOverTime(stepDeviation: stepVariance, strideDeviation: strideVariance, timestamp: Date())
        gaitDataArray.removeAll()
        gaitStandardDeviationOverTime.append(calculatedData)
        saveData()
    }
    
    func sendNotification(){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                print("Notifications denied")
            }
            
        }
        print("sending notification...")
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "You have \(self.getReminderCount()) reminders!"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: "my_notification", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }

    }
    
    func cancelNotification() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if let error = error {
                print("Notifications denied")
            }
            
        }
        center.removeAllPendingNotificationRequests()
    }
    
     
    
}

class GaitOverTime: NSObject, Codable {
    var stepDeviation: Double
    var strideDeviation: Double
    var timestamp: Date
    override var description: String {
        return "\(stepDeviation) \(strideDeviation) \(timestamp)"
    }
    
    init(stepDeviation: Double, strideDeviation: Double, timestamp: Date) {
        self.stepDeviation = stepDeviation
        self.strideDeviation = strideDeviation
        self.timestamp = timestamp
    }
}

class TremorInstensity: NSObject, Codable {
    var standardDeviation: Double
    var timestamp: Date
    override var description: String {
            return "\(standardDeviation) \(timestamp)"
        }
    
    init(standardDeviation: Double, timestamp: Date) {
        self.standardDeviation = standardDeviation
        self.timestamp = timestamp
    }
}

class SavedData: NSObject, Codable {
    var gait: [GaitOverTime]
    var tremor: [TremorInstensity]
    var reminders: [String]
    override var description: String {
            return "\(tremor) \(gait) \(reminders)"
        }
    
    init(gait: [GaitOverTime], tremor: [TremorInstensity], reminders: [String]) {
        self.gait = gait
        self.tremor = tremor
        self.reminders = reminders
    }
    


}
