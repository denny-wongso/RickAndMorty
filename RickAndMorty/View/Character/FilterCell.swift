//
//  FilterCell.swift
//  RickAndMorty
//
//  Created by Denny Wongso on 1/1/23.
//

import Foundation
import UIKit

public class FilterCell: UICollectionViewCell {
    @IBOutlet weak var labelCell: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.labelCell.font = UIFont.systemFont(ofSize: 14)
        self.labelCell.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.labelCell.setContentHuggingPriority(.defaultHigh, for: .horizontal)
     }
}
