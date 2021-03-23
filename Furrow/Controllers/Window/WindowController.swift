//
//  WindowController.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa

class WindowController: NSWindowController {
    
    var patternViewController: PatternViewController? { contentViewController as? PatternViewController }
    
    weak var coordinator: WindowCoordinator?
}
