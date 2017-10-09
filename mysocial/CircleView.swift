//
//  CircleView.swift
//  mysocial
//
//  Created by vagelis spirou on 5/10/17.
//  Copyright © 2017 vagelis spirou. All rights reserved.
//

import UIKit

class CircleView: UIImageView {
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
      
    }
    
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        
//        layer.cornerRadius = self.frame.width / 2
//        layer.clipToBounds = true
//        
//    }
    

}
