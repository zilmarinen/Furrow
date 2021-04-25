//
//  PatternViewController.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import AppKit
import Foundation
import Meadow

class PatternViewController: NSViewController {
    
    @IBOutlet var addMenu: NSMenu!
    
    @IBOutlet weak var footpathMenu: NSMenu! {
        
        didSet {
            
            var items: [NSMenuItem] = []
            
            for option in FootpathTileType.allCases {
                
                let item = NSMenuItem(title: option.description, action: #selector(menuItem(_:)), keyEquivalent: "")
                
                item.tag = option.rawValue
                item.target = self
                
                items.append(item)
            }
            
            footpathMenu.items = items
        }
    }
    
    @IBOutlet weak var surfaceEdgeExteriorItem: NSMenuItem!
    @IBOutlet weak var surfaceEdgeInteriorItem: NSMenuItem!
    @IBOutlet weak var surfaceTileExteriorItem: NSMenuItem!
    @IBOutlet weak var surfaceTileInteriorItem: NSMenuItem!
    
    @IBAction func menuItem(_ sender: NSMenuItem) {
        
        switch sender {
        
        case surfaceEdgeExteriorItem:
            
            coordinator?.import(surface: .edges, environment: .exterior)
            
        case surfaceEdgeInteriorItem:
            
            coordinator?.import(surface: .edges, environment: .interior)
            
        case surfaceTileExteriorItem:
            
            coordinator?.import(surface: .tiles, environment: .exterior)
            
        case surfaceTileInteriorItem:
            
            coordinator?.import(surface: .tiles, environment: .interior)
            
        default:
            
            coordinator?.import(footpath: sender.tag)
        }
    }
    
    weak var coordinator: PatternViewCoordinator?
}
