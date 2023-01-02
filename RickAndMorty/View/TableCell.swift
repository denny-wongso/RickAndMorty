//
//  TableCell.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 2/1/23.
//

import Foundation
import UIKit

public class TableCell: UITableViewCell {
    @IBOutlet weak var labelName: UILabel!
    
    
    func setup(name: String) {
        DispatchQueue.main.async() { [weak self] in
            self?.labelName.text = name
            self?.labelName.font = UIFont.systemFont(ofSize: 14)
        }
    }
}
