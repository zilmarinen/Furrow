//
//  SurfaceTilemap.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Foundation

class SurfaceTilemap: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case edgeset = "e"
        case tileset = "t"
    }
    
    var edgeset: SurfaceEdgeset
    var tileset: SurfaceTileset

    init() {

        edgeset = SurfaceEdgeset()
        tileset = SurfaceTileset()
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        edgeset = try container.decode(SurfaceEdgeset.self, forKey: .edgeset)
        tileset = try container.decode(SurfaceTileset.self, forKey: .tileset)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(edgeset, forKey: .edgeset)
        try container.encode(tileset, forKey: .tileset)
    }
}
