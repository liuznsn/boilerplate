//
//  Constraints.swift
//  Boilerplate
//
//  Created by Leo on 2018/09/13.
//  Copyright © 2018 Leo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @discardableResult func topAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func bottomAnchor(equalTo anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0) -> Self {
        bottomAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func leadingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func trailingAnchor(equalTo anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0) -> Self {
        trailingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        return self
    }
    
    @discardableResult func heightAnchor(equalTo height: CGFloat) -> Self {
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    @discardableResult func widthAnchor(equalTo height: CGFloat) -> Self {
        widthAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
}
