//
//  NSResponder.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa
import Meadow

@objc extension NSResponder {
    
    @objc enum TilemapType: Int {
        
        case edges
        case tiles
    }
    
    @objc enum EnvironmentType: Int {
        
        case exterior
        case interior
    }
    
    func export() throws { try responder?.export() }
    
    func `import`(footpath tileType: Int) { responder?.import(footpath: tileType) }
    func `import`(surface tilemapType: TilemapType, environment: EnvironmentType) { responder?.import(surface: tilemapType, environment: environment) }
    
    var responder: NSResponder? { nextResponder }
}
