//
//  GenericTile.swift
//
//  Created by Zack Brown on 25/09/2021.
//

import AppKit
import Meadow

struct GenericTile {
    
    let identifier: Int
    let season: Season
    let rawType: Int
    let variation: Int
    var image: NSImage
    
    init(tile: FootpathTile) {
        
        identifier = tile.identifier
        season = tile.season
        rawType = tile.tileType.rawValue
        variation = tile.variation
        image = tile.image
    }
    
    init(tile: SurfaceTile) {
        
        identifier = tile.identifier
        season = tile.season
        rawType = tile.overlay.rawValue
        variation = tile.variation
        image = tile.image
    }
}
