import UIKit

extension StyleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let style: Style!
        
        if isSearching {
            style = filteredStyles[collectionView.tag]
        } else {
            style = styles[collectionView.tag]
        }
        
        if let sizes = style.sizes {
            return sizes.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SizeCollectionViewCell", for: indexPath) as? SizeCollectionViewCell else {
            return SizeCollectionViewCell()
        }
        
        let selectedView = UIView()
        selectedView.backgroundColor = ColorPalette.Accent
        cell.selectedBackgroundView = selectedView
        cell.label.textColor = UIColor.white
        
        let style: Style!
        
        if isSearching {
            style = filteredStyles[collectionView.tag]
        } else {
            style = styles[collectionView.tag]
        }
        
        if let sizes = style.sizes {
            let validIndex = sizes.indices.contains(indexPath.item)
            
            if validIndex {
                cell.configureCell(labelText: sizes[indexPath.item])
            } else {
                print("OUT OF RANGE: ", style, sizes[indexPath.item])
                cell.configureCell(labelText: "")
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = IndexPath(row: collectionView.tag, section: 0)
        if let cell = tableView.cellForRow(at: index) as? StyleTableViewCell {
            if (!cell.isSelected) {
                tableView.selectRow(at: index, animated: false, scrollPosition: .none)
            }
        }
    }
    
}
