//
//  FootpathTile.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import AppKit
import Meadow

class FootpathTile: TilesetTile {
    
    enum CodingKeys: String, CodingKey {
            
        case tileType
    }
    
    let tileType: FootpathTileType
    
    required init(filename: String, data: Data) throws {
        
        guard let components = filename.components(separatedBy: ".").first?.components(separatedBy: "_"),
              components.count == 5,
              let identifier = Int(components[1]),
              let seasonIdentifer = Int(components[2]),
              let tileTypeIdentifer = Int(components[3]),
              let variation = Int(components[4]),
              let season = Season(rawValue: seasonIdentifer),
              let tileType = FootpathTileType(rawValue: tileTypeIdentifer),
              let image = NSImage(data: data) else { throw CocoaError(.fileReadCorruptFile) }
        
        self.tileType = tileType
        
        super.init(identifier: identifier, season: season, variation: variation, image: image)
    }
    
    override func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(tileType, forKey: .tileType)
        
        try super.encode(to: encoder)
    }
}

extension FootpathTile {
    
    static func == (lhs: FootpathTile, rhs: FootpathTile) -> Bool {
        
        return  lhs.identifier == rhs.identifier &&
                lhs.season == rhs.season &&
                lhs.tileType == rhs.tileType &&
                lhs.variation == rhs.variation
    }
}

extension Array where Element == FootpathTile {
    
    var blob: [Int : NSImage] {
        
        self.reduce(into: [Int : NSImage]()) { result, element in
            
            result[element.identifier] = element.image
        }
    }
}
