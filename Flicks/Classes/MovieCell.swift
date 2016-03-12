//
//  MovieCell.swift
//  Flicks
//
//  Created by Tien on 3/8/16.
//  Copyright © 2016 Tien. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var voteAverageLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let selectedBgView = UIView()
        selectedBgView.backgroundColor = UIColor(red: 119/255.0, green: 167/255.0, blue: 251/255.0, alpha: 1)
        self.selectedBackgroundView = selectedBgView
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.titleLabel.textColor = UIColor.whiteColor()
            self.overviewLabel.textColor = UIColor.whiteColor()
            self.voteAverageLabel.textColor = UIColor.whiteColor()
        } else {
            self.titleLabel.textColor = UIColor.colorFromRGB(0x262C2F)
            self.overviewLabel.textColor = UIColor.colorFromRGB(0x262C2F)
            self.voteAverageLabel.textColor = UIColor.colorFromRGB(0x262C2F)
        }
    }
}
