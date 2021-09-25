//
//  TilesetTile.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import AppKit
import Foundation
import Meadow

class TilesetTile: Encodable, Equatable, Hashable {
    
    enum CodingKeys: String, CodingKey {
            
        case identifier
        case season
        case variation
    }
    
    let identifier: Int
    let season: Season
    let variation: Int
    var image: NSImage
    
    required init(filename: String, data: Data) throws {
        
        fatalError("init(filename:data:) has not been implemented")
    }
    
    init(identifier: Int,
         season: Season,
         variation: Int,
         image: NSImage) {
        
        self.identifier = identifier
        self.season = season
        self.variation = variation
        self.image = image
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(identifier, forKey: .identifier)
        try container.encode(season, forKey: .season)
        try container.encode(variation, forKey: .variation)
    }
}

extension TilesetTile {
    
    static func == (lhs: TilesetTile, rhs: TilesetTile) -> Bool {
        
        return  lhs.identifier == rhs.identifier &&
                lhs.season == rhs.season &&
                lhs.variation == rhs.variation
    }
    
    func hash(into hasher: inout Hasher) {
        
        hasher.combine(identifier)
        hasher.combine(season)
        hasher.combine(variation)
    }
}
