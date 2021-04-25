//
//  WindowController.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa

class WindowController: NSWindowController {
    
    @IBOutlet weak var addButton: NSButton!
    
    var patternViewController: PatternViewController? { contentViewController as? PatternViewController }
    
    weak var coordinator: WindowCoordinator?
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let menu = patternViewController?.addMenu,
              let event = NSApplication.shared.currentEvent else { return }
        
        NSMenu.popUpContextMenu(menu, with: event, for: sender)
    }
    
    @IBAction func menuItem(_ sender: NSMenuItem) {
        
        try? coordinator?.export()
    }
}
