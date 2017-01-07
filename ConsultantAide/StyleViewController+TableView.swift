import UIKit
import CoreData

extension StyleViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearching {
            return filteredStyles.count
        } else {
            return styles.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StyleCell", for: indexPath) as? StyleTableViewCell {
            
            let style: Style!
            
            if isSearching {
                style = filteredStyles[indexPath.row]
                cell.configureCell(style: style)
            } else {
                style = styles[indexPath.row]
                cell.configureCell(style: style)
            }
            
            return cell
        } else {
            return StyleTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let styleTableViewCell = cell as? StyleTableViewCell else { return }
        styleTableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        
        if cell.isSelected {
            cell.setSelected(true, animated: true)
        } else {
            cell.setSelected(false, animated: false)
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        guard let cell = tableView.cellForRow(at: indexPath) as? StyleTableViewCell else {
            return false
        }
        
        if cell.belongsToCustomLabel() {
            return true
        }
        
        return false
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? StyleTableViewCell else {
            return
        }
        
        if (editingStyle == .delete) {
            styles.remove(at: indexPath.row)
            tableView.reloadData()
            
            if let style = cell.style {
                context.delete(style)
                ad.saveContext()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addToEditorBtn.isEnabled = true
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        addToEditorBtn.isEnabled = false
    }
}
