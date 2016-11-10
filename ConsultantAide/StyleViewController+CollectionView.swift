import UIKit

extension StyleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let indexPath = IndexPath(row: collectionView.tag, section: 0)
        let style = styleResultsController.object(at: indexPath)
        
        if let sizes = style.sizes {
            return sizes.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell {
            
            let selectedView = UIView()
            selectedView.backgroundColor = ColorPalette.Accent
            cell.selectedBackgroundView = selectedView
            cell.label.textColor = UIColor.white
            
            let path = IndexPath(row: collectionView.tag, section: 0)
            let style = styleResultsController.object(at: path)
            
            if let sizes = style.sizes {
                
                let validIndex = sizes.indices.contains(indexPath.item)
                
                if validIndex {
                    cell.configureCell(labelText: sizes[indexPath.item])
                } else {
                    print("OUT OF RANGE: ", style, sizes[indexPath.item])
                    cell.configureCell(labelText: "")
                }
            }
            
            let index = IndexPath(row: collectionView.tag, section: 0)
            
            if let selectedCells = selectedPaths[index] {
                for selectedCell in selectedCells {
                    collectionView.selectItem(at: selectedCell, animated: false, scrollPosition: .init(rawValue: 0))
                }
            }
            
            return cell
        } else {
            return SizeCollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: collectionView.tag, section: 0)
        if let cell = tableView.cellForRow(at: index) as? StyleTableViewCell {
            if (!cell.isSelected) {
                tableView.selectRow(at: index, animated: false, scrollPosition: .none)
            }
            
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            selectedPaths[index] = collectionView.indexPathsForSelectedItems
            
            if let style = cell.primaryLabel.text {
                if (selectedItems.index(forKey: style) == nil) { selectedItems[style] = Set<String>() }
                if let paths = collectionView.indexPathsForSelectedItems {
                    for path in paths {
                        if let sizeCell = collectionView.cellForItem(at: path) as? SizeCollectionViewCell {
                            if let size = sizeCell.label.text {
                                selectedItems[style]?.insert(size)
                            }
                        }
                    }
                }
            }
            
            if let style = cell.style {
                if (selectedStyles.index(forKey: style) == nil) { selectedStyles[style] = [] }
                
                guard let paths = collectionView.indexPathsForSelectedItems else {
                    print("Could not get selected paths for size collection view")
                    return
                }
                
                var selectedSizes: Set<String> = []
                
                for path in paths {
                    guard let sizeCell = collectionView.cellForItem(at: path) as? SizeCollectionViewCell else {
                        print("Could not grab selected size cell in size collection view")
                        return
                    }
                    
                    if let size = sizeCell.label.text {
                        selectedSizes.insert(size)
                    }
                }
                
                selectedStyles.updateValue(selectedSizes, forKey: style)
            }
            
        }
        
        print("selected: \(selectedStyles)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: collectionView.tag, section: 0)
        selectedPaths[index] = collectionView.indexPathsForSelectedItems
        
        if let cell = tableView.cellForRow(at: index) as? StyleTableViewCell {
            if let style = cell.primaryLabel.text {
                if let sizeCell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell {
                    if let size = sizeCell.label.text {
                        _ = selectedItems[style]?.remove(size)
                    }
                }
            }
        }
        
        if let cell = tableView.cellForRow(at: index) as? StyleTableViewCell {
            guard let sizeCell = collectionView.cellForItem(at: indexPath) as? SizeCollectionViewCell else {
                print("Unable to find size cell for collection view")
                return
            }
            
            guard let size = sizeCell.label.text else {
                print("Could not get size when deselecting a size collection view cell")
                return
            }
            
            _ = selectedStyles[cell.style]?.remove(size)
        }
        
        print("selected: \(selectedStyles)")
    }
    
}
