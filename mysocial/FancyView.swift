//
//  FancyView.swift
//  mysocial
//
//  Created by vagelis spirou on 3/10/17.
//  Copyright © 2017 vagelis spirou. All rights reserved.
//

import UIKit

class FancyView: UIView {

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        
    }
    
    

}
