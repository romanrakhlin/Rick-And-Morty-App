//
//  CustomTableViewCell.swift
//  Rick And Morty's Multiverse
//
//  Created by Roman Rakhlin on 13.09.2021.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var portretImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        bubbleView.layer.cornerRadius = bubbleView.frame.size.height / 5
        portretImage.layer.cornerRadius = portretImage.frame.size.height / 5
        
        // shadow of cell
        bubbleView.layer.shadowColor = UIColor.black.cgColor
        bubbleView.layer.shadowOpacity = 0.4
        bubbleView.layer.shadowOffset = .zero
        bubbleView.layer.shadowRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
