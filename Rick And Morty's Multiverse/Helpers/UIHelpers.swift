//
//  UIHelpers.swift
//  Rick And Morty's Multiverse
//
//  Created by Roman Rakhlin on 15.09.2021.
//

import UIKit

struct UIHelper {
   
    static func createSingleColumnFlowLayout(in view : UIView) -> UICollectionViewFlowLayout {
        
        let width = view.bounds.width
        let padding: CGFloat = 12
        let minimunItemSpacing: CGFloat = 10
        
        let availableWidth = width - (padding * 2) - (minimunItemSpacing * 2)
        let itemWidth      = availableWidth
        
        let flowLayaout            = UICollectionViewFlowLayout()
        flowLayaout.sectionInset   = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayaout.itemSize       = CGSize(width: itemWidth, height: itemWidth + 70)
        return flowLayaout
    }
    
}
