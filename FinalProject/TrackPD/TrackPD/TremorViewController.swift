//
//  TremorsViewController.swift
//  Darrion Shack (dashack@iu.edu)
//  Jason Mai (jasmai@iu.edu)
//  NeuroTrack
//  Submission Date: 04/30/23
//
//  Created by Darrion Shack on 4/14/23.
//

import UIKit

class TremorViewController: UIViewController {
    var theAppDelegate: AppDelegate?
    var theModel: ParkinsonsModel!
    var lastTremor:Double = 0
    var timer: Timer?
    
    @IBOutlet weak var currentTremorLabel: UILabel!
    @IBOutlet weak var changeIdentifier: UIButton!
    @IBOutlet weak var tremorTypeLabel: UILabel!
    @IBOutlet weak var averageTremorLabel: UILabel!
    
    @IBOutlet weak var timeRange: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.theModel = self.theAppDelegate?.theModel
        // Do any additional setup after loading the view.
        getCurrentTremors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func getTremorFromRange(_ sender: Any) {
        if(timeRange.selectedSegmentIndex == 0) {
            getDailyTremors()
        } else if(timeRange.selectedSegmentIndex == 1) {
            getWeeklyTremors()
        } else if(timeRange.selectedSegmentIndex == 2) {
            getMonthlyTremors()
        } else {
            getYearlyTremors()
        }
    }
    func getCurrentTremors() {
        /*
         Calculates the user's current tremors over the last minute
         returns the value to the currentTremorsLabel
         */
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            var currTremor = self.theModel.getCurrentTremors()
            if(currTremor > self.lastTremor) {
                self.changeIdentifier.setImage(UIImage(systemName: "chevron.up"), for: .normal)
                self.changeIdentifier.tintColor = .systemRed
            } else {
                self.changeIdentifier.setImage(UIImage(systemName: "chevron.down"), for: .normal)
                self.changeIdentifier.tintColor = .systemBlue
            }
            let formattedNum = String(format: "%.4f", currTremor)
            self.currentTremorLabel.text = "\(formattedNum) mm/s"
            self.lastTremor = currTremor
        }}
    
    func getDailyTremors() {
        let tremors = theModel.calculateByTimeFrame(timeFrame: 1, metric: "tremor")
        tremorTypeLabel.text = "Average Tremors (Day)"
        let formattedTremor = String(format: "%.4f", tremors)
        averageTremorLabel.text = "\(formattedTremor) mm/s"
    }
    
    func getWeeklyTremors() {
        let tremors = theModel.calculateByTimeFrame(timeFrame: 7, metric: "tremor")
        tremorTypeLabel.text = "Average Tremors (Week)"
        let formattedTremor = String(format: "%.4f", tremors)
        averageTremorLabel.text = "\(formattedTremor) mm/s"
    }
    
    func getMonthlyTremors() {
        let tremors = theModel.calculateByTimeFrame(timeFrame: 30, metric: "tremor")
        tremorTypeLabel.text = "Average Tremors (Month)"
        let formattedTremor = String(format: "%.4f", tremors)
        averageTremorLabel.text = "\(formattedTremor) mm/s"
    }
    
    func getYearlyTremors() {
        let tremors = theModel.calculateByTimeFrame(timeFrame: 365, metric: "tremor")
        tremorTypeLabel.text = "Average Tremors (Year)"
        let formattedTremor = String(format: "%.4f", tremors)
        averageTremorLabel.text = "\(formattedTremor) mm/s"
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
