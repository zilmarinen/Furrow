//
//  FootpathTilemap.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Foundation

class FootpathTilemap: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case tileset = "t"
    }
    
    var tileset: FootpathTileset

    init() {

        tileset = FootpathTileset()
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        tileset = try container.decode(FootpathTileset.self, forKey: .tileset)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(tileset, forKey: .tileset)
    }
}
