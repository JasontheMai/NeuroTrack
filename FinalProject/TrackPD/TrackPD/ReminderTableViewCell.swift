//
//  ReminderTableViewCell.swift
//  Darrion Shack (dashack@iu.edu)
//  Jason Mai (jasmai@iu.edu)
//  NeuroTrack
//  Submission Date: 04/30/23
//
//  Created by Darrion Shack on 4/14/23.
//

import UIKit

class ReminderTableViewCell: UITableViewCell {
    @IBOutlet weak var reminderTitleLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIButton!
    var toDelete = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteSelf(_ sender: Any) {
        if(!toDelete) {
            doneButton.backgroundColor = .systemRed
            doneButton.setTitle("Done", for: UIControl.State.normal)
            /*
             Will add logic to delete the reminder from the model when the button is pressed.
             end functon
             */
        } else {
            doneButton.backgroundColor = .systemOrange
            doneButton.setTitle("Mark Done", for: UIControl.State.normal)
            toDelete = false
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
