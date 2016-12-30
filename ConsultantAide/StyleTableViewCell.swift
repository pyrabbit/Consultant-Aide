//
//  StyleTableViewCell.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 9/7/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit

class StyleTableViewCell: UITableViewCell {

    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var mapLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var kidsImage: UIImageView!
    
    var style: Style!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        primaryLabel.textColor = ColorPalette.Primary
        collectionView.allowsMultipleSelection = true
    }
    
    func configureCell(style: Style) {
        self.style = style
        primaryLabel.text = style.name
        brandLabel.text = style.brand
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        var priceString = "N/A"
        
        if style.price > 0 {
            if let newPriceString = formatter.string(from: NSNumber(value: style.price)) {
                priceString = newPriceString
            }
        }
        
        if style.forKids {
            kidsImage.isHidden = false
        } else {
            kidsImage.isHidden = true
        }
        
        mapLabel.text = priceString
    }
    
    func belongsToCustomLabel() -> Bool {
        guard let brand = style.brand else {
            return false
        }
        
        if brand == "Custom" {
            return true
        }
        
        return false
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(_: selected, animated: animated)
        
        if (selected) {
            self.backgroundColor = ColorPalette.Primary
            self.primaryLabel.textColor = UIColor.white
            self.mapLabel.textColor = ColorPalette.Accent
        } else {
            self.backgroundColor = UIColor.white
            self.primaryLabel.textColor = ColorPalette.Primary
            self.mapLabel.textColor = ColorPalette.Primary
            deselectAllInCollectionView()
        }
    }
    
    func deselectAllInCollectionView() {
        if let selectedSizes = self.collectionView.indexPathsForSelectedItems {
            for index in selectedSizes {
                self.collectionView.deselectItem(at: index, animated: false)
            }
        }
    }
    
    func setCollectionViewDataSourceDelegate
        <D: UICollectionViewDataSource & UICollectionViewDelegate>
        (dataSourceDelegate: D, forRow row: Int) {
        
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
    
}
