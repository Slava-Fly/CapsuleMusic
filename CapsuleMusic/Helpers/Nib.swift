//
//  Nib.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 15.10.2025.
//

import UIKit

extension UIView {
    
    class func loadFromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
}
