//
//  SizeCollectionViewCell.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 9/7/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit

class SizeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.layer.cornerRadius = 5
        self.label.textColor = UIColor.white
        self.clipsToBounds = true
        
        if self.isSelected {
            self.backgroundColor = ColorPalette.Accent
        } else {
            self.backgroundColor = ColorPalette.Primary
        }
    }
    
    func configureCell(labelText: String) {
        label.text = labelText
    }
}
