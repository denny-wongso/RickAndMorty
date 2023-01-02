//
//  CharacterCell.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 30/12/22.
//

import Foundation
import UIKit

public class CharacterCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPlace: UILabel!
    
    
    func setup(name: String, place: String) {
        self.layer.cornerRadius = 15
        DispatchQueue.main.async() { [weak self] in
            self?.labelName.text = name
            self?.labelPlace.text = place
        }
    }
    
    func addImage(image: Data) {
        DispatchQueue.main.async() { [weak self] in
            self?.imageView.image = UIImage(data: image)
        }
    }
    
}
