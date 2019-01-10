//
//  PaddingLabel.swift
//  Thoughtful Quotes
//
//  Created by Raj Gupta on 11/1/19.
//  Copyright © 2019 SoulfulMachine. All rights reserved.
//

import UIKit

class PaddingLabel: UILabel {

    let topInset: CGFloat = 5.0
    let bottomInset: CGFloat = 5.0
    let leftInset: CGFloat = 7.0
    let rightInset: CGFloat = 7.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
}
