//
//  SurfaceTile.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import AppKit
import Meadow

class SurfaceTile: TilesetTile {
    
    enum CodingKeys: String, CodingKey {
        
        case overlay
    }
    
    let overlay: SurfaceOverlay
    
    required init(filename: String, data: Data) throws {
        
        guard let components = filename.components(separatedBy: ".").first?.components(separatedBy: "_"),
              components.count == 5,
              let identifier = Int(components[1]),
              let seasonIdentifer = Int(components[2]),
              let overlayIdentifer = Int(components[3]),
              let variation = Int(components[4]),
              let season = Season(rawValue: seasonIdentifer),
              let overlay = SurfaceOverlay(rawValue: overlayIdentifer),
              let image = NSImage(data: data) else { throw CocoaError(.fileReadCorruptFile) }
        
        self.overlay = overlay
        
        super.init(identifier: identifier, season: season, variation: variation, image: image)
    }
    
    override func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(overlay, forKey: .overlay)
        
        try super.encode(to: encoder)
    }
}

extension SurfaceTile {
    
    static func == (lhs: SurfaceTile, rhs: SurfaceTile) -> Bool {
        
        return  lhs.identifier == rhs.identifier &&
                lhs.season == rhs.season &&
                lhs.overlay == rhs.overlay &&
                lhs.variation == rhs.variation
    }
}

extension Array where Element == SurfaceTile {
    
    var blob: [Int : NSImage] {
        
        self.reduce(into: [Int : NSImage]()) { result, element in
            
            result[element.identifier] = element.image
        }
    }
}
