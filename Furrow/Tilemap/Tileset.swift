//
//  Tileset.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Meadow

enum Tileset: CaseIterable, Hashable, Identifiable {
    
    static var allCases: [Tileset] = [.footpath(.dirt),
                                      .surface(.grass)]
    
    case footpath(FootpathTileType)
    case surface(SurfaceOverlay)
    
    var id: String {
        
        switch self {
            
        case .footpath: return "footpath"
        default: return "surface"
        }
    }
    
    var imageName: String {
        
        switch self {
            
        case .footpath: return "doc"
        default: return "folder"
        }
    }
}
