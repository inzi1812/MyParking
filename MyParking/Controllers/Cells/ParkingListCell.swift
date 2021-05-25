//
//  ParkingListCell.swift
//  MyParking
//
//  Created by RD on 22/05/21.
//

import UIKit

class ParkingListCell: UITableViewCell {
    
    @IBOutlet weak var tfCarPlateNumber: UILabel!
    @IBOutlet weak var tfDate: UILabel!
    @IBOutlet weak var tfAddress: UILabel!
    @IBOutlet weak var tfParkingHours: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
