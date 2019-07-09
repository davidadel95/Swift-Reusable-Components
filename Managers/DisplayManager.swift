//
//  DisplayManager.swift
//
//  Created by David Adel on 7/2/19.
//  Copyright © 2019 DavidAdel. All rights reserved.
//

import Foundation
import UIKit

class DisplayManager {
    struct Screen {
        static var width: CGFloat!
        static var height: CGFloat!
    }
    
    static func setSizeVars(window: UIWindow!) {
        DisplayManager.Screen.width = (window?.frame.width)!
        DisplayManager.Screen.height = (window?.frame.height)!
    }
    
    static func getFullScreenRect() -> CGRect {
        return CGRect(x: 0,
                      y: 0,
                      width: DisplayManager.Screen.width,
                      height: DisplayManager.Screen.height)
    }
}
