//
//  StyleTableViewCell.swift
//  ConsultantAide
//
//  Created by Matt Orahood on 9/7/16.
//  Copyright © 2016 Matt Orahood. All rights reserved.
//
import UIKit

class StyleTableViewCell: UITableViewCell {
    /*
     // MARK: - IBOutlet Definitions
     */
    
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    /*
     // MARK: - Initialization
     */
    
    var style: Style!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        primaryLabel.textColor = ColorPalette.Primary
        collectionView.allowsMultipleSelection = true
    }
    
    /*
     // MARK: - Configuration
     */
    
    func configureCell(primaryText: String) {
        self.primaryLabel.text = primaryText
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(_: selected, animated: animated)
        
        if (selected) {
            self.backgroundColor = ColorPalette.Primary
            self.primaryLabel.textColor = UIColor.white
        } else {
            self.backgroundColor = UIColor.white
            self.primaryLabel.textColor = ColorPalette.Primary
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
