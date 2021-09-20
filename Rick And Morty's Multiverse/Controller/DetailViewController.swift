//
//  DetailViewController.swift
//  Rick And Morty's Multiverse
//
//  Created by Roman Rakhlin on 13.09.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bubbleView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var portretImage: UIImageView!
    @IBOutlet weak var portretImageView: UIView!
    
    var name: String?
    var status: String?
    var location: String?
    var episode: String?
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // shadow of bubble view
        bubbleView.layer.shadowColor = UIColor.black.cgColor
        bubbleView.layer.shadowOpacity = 0.8
        bubbleView.layer.shadowOffset = .zero
        bubbleView.layer.shadowRadius = 8
        
        // shadow of view for avatar image
        portretImageView.layer.shadowColor = UIColor.black.cgColor
        portretImageView.layer.shadowOpacity = 0.4
        portretImageView.layer.shadowOffset = .zero
        portretImageView.layer.shadowRadius = 10
        
        // round bubble view
        bubbleView.layer.cornerRadius = bubbleView.frame.size.height / 8
        
        // round avatar image
        portretImage.layer.cornerRadius = portretImage.frame.size.height / 10
        
        // round of view for avatar image
        portretImageView.layer.cornerRadius = portretImage.frame.size.height / 10
        
        // setting info
        navigationItem.title = name
        statusLabel.text = status
        locationLabel.text = location
        episodeLabel.text = episode
        portretImage.image = image
    }
}
