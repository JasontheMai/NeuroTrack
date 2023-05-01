//
//  GaitViewController.swift
//  Darrion Shack (dashack@iu.edu)
//  Jason Mai (jasmai@iu.edu)
//  NeuroTrack
//  Submission Date: 04/30/23
//
//  Created by Darrion Shack on 4/14/23.
//

import UIKit
import Charts

class GaitViewController: UIViewController {
    var theAppDelegate: AppDelegate?
    var theModel: ParkinsonsModel!
    @IBOutlet weak var currentGaitLabel: UILabel!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var gaitTypeLabel: UILabel!
    @IBOutlet weak var averageGaitLabel: UILabel!
    @IBOutlet weak var changeIdentifier: UIButton!
    var lastGait:Double = 0
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.theModel = self.theAppDelegate?.theModel
        getCurrentGait()
        // Do any additional setup after loading the view.
    }
    func getCurrentGait() {
        /*
         Calculates the user's current gait over the last minute
         returns the value to the currentGaitLabel
         */
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) {
            [weak self] timer in
            guard let self = self else { return }
            var currGait = self.theModel.getCurrentGait()
            if(currGait > self.lastGait) {
                self.changeIdentifier.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                self.changeIdentifier.tintColor = .systemRed
            } else {
                self.changeIdentifier.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                self.changeIdentifier.tintColor = .systemBlue
            }
            let formattedNum = String(format: "%.10f", currGait)
            self.currentGaitLabel.text = "\(formattedNum) m/s"
            self.lastGait = currGait
        }}
    
    func getDailyGait() {
        let gait = theModel.calculateByTimeFrame(timeFrame: 1, metric: "gait")
        gaitTypeLabel.text = "Average Gait (Day)"
        let formattedGait = String(format: "%.4f", gait)
        averageGaitLabel.text = "\(formattedGait) m"
    }
    
    func getWeeklyGait() {
        let gait = theModel.calculateByTimeFrame(timeFrame: 7, metric: "gait")
        gaitTypeLabel.text = "Average Gait (Week)"
        let formattedGait = String(format: "%.4f", gait)
        averageGaitLabel.text = "\(formattedGait) m"
    }
    
    func getMonthlyGait() {
        let gait = theModel.calculateByTimeFrame(timeFrame: 31, metric: "gait")
        gaitTypeLabel.text = "Average Gait (Month)"
        let formattedGait = String(format: "%.4f", gait)
        averageGaitLabel.text = "\(formattedGait) m"
    }
    
    func getYearlyGait() {
        let gait = theModel.calculateByTimeFrame(timeFrame: 365, metric: "gait")
        gaitTypeLabel.text = "Average Gait (Year)"
        let formattedGait = String(format: "%.4f", gait)
        averageGaitLabel.text = "\(formattedGait) m"
    }
    
    @IBAction func processSegmentControl(_ sender: Any) {
        if(segmentController.selectedSegmentIndex == 0) {
            getDailyGait()
        } else if(segmentController.selectedSegmentIndex == 1) {
            getWeeklyGait()
        } else if(segmentController.selectedSegmentIndex == 2) {
            getMonthlyGait()
        } else {
            getYearlyGait()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
