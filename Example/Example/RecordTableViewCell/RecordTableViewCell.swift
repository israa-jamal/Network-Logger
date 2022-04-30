//
//  RecordTableViewCell.swift
//  Example
//
//  Created by Esraa Gamal on 30/04/2022.
//

import UIKit
import InstabugNetworkClient

class RecordTableViewCell: UITableViewCell {

    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var statusCodeLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCellWith(_ record: Record) {
        methodLabel.text = record.request?.method
        urlLabel.text = record.request?.url
        if let code = record.response?.statusCode {
            statusCodeLabel.text = "\(code)"
        } else {
            statusCodeLabel.text = "ERROR"
        }
        errorLabel.text = record.response?.error?.domain ?? "There is no Error"
    }
}
