//
//  CustomTextFields.swift
//  Elixr
//
//  Created by Timothy Richardson on 10/6/17.
//  Copyright © 2017 Timothy Richardson. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTextFields: UITextField {

    // Can help adjust the custom radius in the insepctor.
    @IBInspectable var cornerRadius:CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = cornerRadius > 0
        }
    }
    
    // Can be used to adjust the border width for buttons in the inspector.
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    // Can be used to customise the background colours in the inspector.
    @IBInspectable var borderColor:UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
