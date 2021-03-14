//
//  Extension+UIView.swift
//  RetailApp
//
//  Created by Janak Shah on 14/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import UIKit

extension UIView {
    
    func add(_ views: UIView...) {
        for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    
    func pinTo(top topMargin: CGFloat? = nil, bottom bottomMargin: CGFloat? = nil, left leftMargin: CGFloat? = nil, right rightMargin: CGFloat? = nil) {
        guard let superview = superview else {
            fatalError("⚠️ View has no superview")
        }
        if let topMargin = topMargin {
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: topMargin).isActive = true
        }
        if let bottomMargin = bottomMargin {
            superview.safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomMargin).isActive = true
        }
        if let leftMargin = leftMargin {
            leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: leftMargin).isActive = true
        }
        if let rightMargin = rightMargin {
            superview.safeAreaLayoutGuide.rightAnchor.constraint(equalTo: rightAnchor, constant: rightMargin).isActive = true
        }
    }
    
    func alignYAxis() {
        guard let superview = superview else {
            fatalError("⚠️ View has no superview")
        }
        centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
    }
    
    func alignXAxis() {
        guard let superview = superview else {
            fatalError("⚠️ View has no superview")
        }
        centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
    }
    
    func pinHeight(_ height: CGFloat) {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func pinWidth(_ width: CGFloat) {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
}
