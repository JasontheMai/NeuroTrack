//
//  RemindersViewController.swift
//  Darrion Shack (dashack@iu.edu)
//  Jason Mai (jasmai@iu.edu)
//  NeuroTrack
//  Submission Date: 04/30/23
//
//  Created by Darrion Shack on 4/14/23.
//

import UIKit
import UserNotifications

class RemindersViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reminderTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var theAppDelegate: AppDelegate?
    var theModel: ParkinsonsModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.theAppDelegate = UIApplication.shared.delegate as? AppDelegate
        self.theModel = self.theAppDelegate?.theModel
        self.reminderTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func addReminder(_ sender: Any) {
        titleLabel.isHidden = false
        reminderTextField.isHidden = false
        confirmButton.isHidden = false
    }
    
    
    @IBAction func confirmReminder(_ sender: Any) {
        titleLabel.isHidden = true
        reminderTextField.isHidden = true
        confirmButton.isHidden = true
        if(reminderTextField.text != "") {
            theModel.addReminder(reminder: reminderTextField.text!)
        }
        view.endEditing(true)
        reminderTextField.text = ""
        
    }
    
    @IBAction func clearReminders(_ sender: Any) {
        deleteLabel.isHidden = false
        deleteButton.isHidden = false
        cancelButton.isHidden = false
        reminderTextField.isHidden = true
        confirmButton.isHidden = true
        titleLabel.isHidden = true
    }
    
    @IBAction func cancelDelete(_ sender: Any) {
        deleteLabel.isHidden = true
        deleteButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @IBAction func deleteAllReminders(_ sender: Any) {
        theModel.deleteReminders()
        theModel.cancelNotification()
        deleteLabel.isHidden = true
        deleteButton.isHidden = true
        cancelButton.isHidden = true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("here")
            reminderTextField.resignFirstResponder()
        confirmReminder(textField)
            return true
        
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
