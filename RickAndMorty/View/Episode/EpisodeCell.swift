//
//  EpisodeCell.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation
import UIKit
public class EpisodeCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelseason: UILabel!
    @IBOutlet weak var labelEpisode: UILabel!
    @IBOutlet weak var labelAirDate: UILabel!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
     }
    
    func setup(name: String, season: String, episode: String, airDate: String) {
        DispatchQueue.main.async() { [weak self] in
            self?.labelName.text = name
            self?.labelseason.text = "season: " + season
            self?.labelEpisode.text = "episode: " + episode
            self?.labelAirDate.text = airDate

        }
    }
}
