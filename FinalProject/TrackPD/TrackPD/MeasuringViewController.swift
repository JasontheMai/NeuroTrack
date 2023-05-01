//
//  MeasuringViewController.swift
//  Darrion Shack (dashack@iu.edu)
//  Jason Mai (jasmai@iu.edu)
//  NeuroTrack
//  Submission Date: 04/30/23
//
//  Created by Jason Mai on 4/15/23

import UIKit
import CoreMotion

class MeasuringViewController: UIViewController {
    
    var theAppDelegate: AppDelegate?
    var theModel: ParkinsonsModel!
    
    
    var isMeasuring = false
    let pedometer = CMPedometer()
    
    
    @IBOutlet weak var gaitLabel: UITextView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var measuringButton: UIButton!
    
    var timer: Timer?
    var gaitTimer: Timer?

    let motionManager = CMMotionManager()
    var gyroData: CMGyroData?
    var accData: CMAccelerometerData?
    let activityManager = CMMotionActivityManager()
    var isGaitMeasuring = false

    @IBAction func tremors(_ sender: Any) {
        if isMeasuring {
            measuringButton.backgroundColor = .systemYellow
            measuringButton.setTitleColor(.black, for: .normal)
            measuringButton.setTitle("Start Measuring", for: .normal)
            // Stop measuring and save the data
            isMeasuring = false
            timer?.invalidate()
            let timestamp = Date()
            
            if let gyroData = gyroData, let accData = accData {
                print(gyroData)
                self.theModel.addGyroData(rotationRateX: gyroData.rotationRate.x, rotationRateY: gyroData.rotationRate.y, rotationRateZ: gyroData.rotationRate.z, timestamp: timestamp)
                print(accData)
                self.theModel.addAccelData(accelerationX: accData.acceleration.x, accelerationY: accData.acceleration.y, accelerationZ: accData.acceleration.z, timestamp: timestamp)
                
            }
            
        } else {
            // Start measuring
            isMeasuring = true
            measuringButton.backgroundColor = .red
            measuringButton.setTitleColor(.white, for: .normal)
            measuringButton.setTitle("Stop Measuring", for: .normal)
            textField.text = ""
            startMeasurement()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.text = ""
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.theModel = self.theAppDelegate?.theModel
    }
    
    func startMeasurement() {
        activityManager.startActivityUpdates(to: OperationQueue.main) { (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if activity.stationary {
                    print("Stationary")
                } else if activity.walking {
                    print("Walking")
                } else if activity.running {
                    print("Running")
                } else if activity.automotive {
                    print("Automotive")
                }
            }
        }
        if CMPedometer.isStepCountingAvailable() && CMPedometer.isDistanceAvailable() {
            motionManager.deviceMotionUpdateInterval = 0.2
            pedometer.startUpdates(from: Date()) { pedometerData, error in
                guard let data = pedometerData, error == nil else {
                    print("Error: \(error!)")
                    return
                }
                let stepCount = data.numberOfSteps.intValue
                let distance = data.distance?.doubleValue ?? 0.0
                let strideLength = distance / Double(stepCount)
                let timestamp = Date()
                print("Step count: \(stepCount)")
                print("Stride length: \(strideLength)")
                print("Distance: \(distance)")
                self.theModel.addGaitData(stepCount: stepCount, distance: distance, strideLength: strideLength, timestamp: timestamp)
            }
            
        } else {
            print("Pedometer not available")
        }
        
        // Check if gyroscope and accelerometer are available
        if motionManager.isGyroAvailable && motionManager.isAccelerometerAvailable {
            
            // Set up update intervals for gyroscope and accelerometer data
            motionManager.gyroUpdateInterval = 0.1
            motionManager.accelerometerUpdateInterval = 0.1
            
            // Start gyroscope and accelerometer updates
            motionManager.startGyroUpdates()
            motionManager.startAccelerometerUpdates()
            
            // Create a timer that fires at regular intervals and collects the gyroscope and accelerometer data
            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                
                // Get the latest gyroscope data and store it in a variable
                self.textField.scrollRangeToVisible(NSMakeRange(self.textField.text.count - 1, 0))
                self.gaitLabel.scrollRangeToVisible(NSMakeRange(self.gaitLabel.text.count - 1, 0))
                if let gyroData = self.motionManager.gyroData {
                    self.gyroData = gyroData
                    self.gaitLabel.text += "\(gyroData)\n"
                    //print("Current gyro data: \(gyroData)")
                    let timestamp = Date()
                    self.theModel.addGyroData(rotationRateX: gyroData.rotationRate.x, rotationRateY: gyroData.rotationRate.y, rotationRateZ: gyroData.rotationRate.z, timestamp: timestamp)
                    
                }
                
                // Get the latest accelerometer data and store it in a variable
                if let accData = self.motionManager.accelerometerData {
                    self.accData = accData
                    self.textField.text += "\(accData)\n"
                    //print("Current acc data: \(accData)")
                    let timestamp = Date()
                    self.theModel.addAccelData(accelerationX: accData.acceleration.x, accelerationY: accData.acceleration.y, accelerationZ: accData.acceleration.z, timestamp: timestamp)
                    
                }
            }
        }
    }
    
    
    
    
    
}
