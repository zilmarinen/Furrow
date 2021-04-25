//
//  Tilemap.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Foundation

class Tilemap: NSObject, Codable, StartOption {
    
    enum CodingKeys: String, CodingKey {
        
        case footpath = "f"
        case surface = "s"
    }
    
    var footpath: FootpathTilemap

    var surface: SurfaceTilemap

    override init() {

        footpath = FootpathTilemap()

        surface = SurfaceTilemap()

        super.init()
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        footpath = try container.decode(FootpathTilemap.self, forKey: .footpath)
        surface = try container.decode(SurfaceTilemap.self, forKey: .surface)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(footpath, forKey: .footpath)
        try container.encode(surface, forKey: .surface)
    }
}
