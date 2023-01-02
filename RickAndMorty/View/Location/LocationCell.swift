//
//  LocationCell.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation
import UIKit

public class LocationCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var labelDimension: UILabel!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
     }
    
    func setup(name: String, location: String, dimension: String) {
        DispatchQueue.main.async() { [weak self] in
            self?.labelName.text = name
            self?.labelLocation.text = location
            self?.labelDimension.text = dimension
        }
    }
}
