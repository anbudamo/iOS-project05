//
//  TumblrCell.swift
//  ios101-project5-tumblr
//
//  Created by Anbu Damodaran on 10/20/23.
//

import UIKit

class TumblrCell: UITableViewCell {

    @IBOutlet weak var cImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
