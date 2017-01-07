//
//  LabelEditorViewController+SavedLabelServiceDelegate.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 1/7/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

extension LabelEditorViewController: SavedLabelServiceDelegate {
    func didFetch(savedLabels: [SavedLabel]?) {
        guard let data = savedLabels else {
            print("Saved labels returned nil. Nothing to update.")
            return
        }
        
        _ = labels.map { label in label.removeFromSuperview() }
        
        labels = data.map { label in
            let styleView = StyleView(savedLabel: label)
            styleView.containWithin(view: labelContainer)
            styleView.moveToSavedPosition()
            return styleView
        }
        
        _ = labels.map { label in labelContainer.addSubview(label) }
    }
}
