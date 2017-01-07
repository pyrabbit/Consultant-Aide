//
//  LabelEditorViewController+CollageSourceDelegate.swift
//  ConsultantAide
//
//  Created by Matthew Orahood on 1/7/17.
//  Copyright © 2017 Matthew Orahood. All rights reserved.
//

import UIKit

extension LabelEditorViewController: CollageSourceViewDelegate {
    func didCancel(view: CollageSourceView) {
        view.removeFromSuperview()
        modalBackground?.removeFromSuperview()
    }
}
