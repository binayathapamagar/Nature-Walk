//
//  UIWindowExtension.swift
//  Touchdown
//
//  Created by BINAYA THAPA MAGAR on 2024-06-21.
//

import SwiftUI

extension UIWindow {
    
    ///Get the current Window.
    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
    
}
