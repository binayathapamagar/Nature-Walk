//
//  UIScreenExtension.swift
//  Touchdown
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import SwiftUI

extension UIScreen {
    
    ///Get the curent screen.
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
    
}
