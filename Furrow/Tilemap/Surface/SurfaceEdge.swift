//
//  SurfaceEdge.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa
import Foundation
import Meadow

class SurfaceEdge: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case pattern = "p"
        case uvs = "uv"
    }
    
    let pattern: Int
    var uvs: UVs?
    var image: NSImage?
    
    init(pattern: Int, image: NSImage) {
        
        self.pattern = pattern
        self.image = image
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        pattern = try container.decode(Int.self, forKey: .pattern)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(pattern, forKey: .pattern)
        try container.encodeIfPresent(uvs, forKey: .uvs)
    }
}
