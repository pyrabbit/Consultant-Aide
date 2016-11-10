import UIKit
import CoreData

extension StyleViewController: UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = styleResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = styleResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "StyleCell", for: indexPath) as? StyleTableViewCell {
            let style = styleResultsController.object(at: indexPath as IndexPath)
            cell.configureCell(style: style)
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
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StyleTableViewCell {
            selectedPaths.removeValue(forKey: indexPath)
            
            if let style = cell.style {
                selectedStyles.removeValue(forKey: style)
            }
            
            print("selected: \(selectedStyles)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? StyleTableViewCell {
            selectedPaths[indexPath] = []
            
            if let style = cell.primaryLabel.text {
                selectedItems[style] = []
            }
            
            if let style = cell.style {
                selectedStyles[style] = []
            }
            
            print("selected: \(selectedStyles)")
        }
    }
    
    func loadStyles() {
        let fetchRequest: NSFetchRequest<Style> = Style.fetchRequest()
        let nameSort = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [nameSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        self.styleResultsController = controller
        
        do {
            try controller.performFetch()
        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
 
}
