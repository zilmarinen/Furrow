//
//  FootpathMaterial.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import Meadow

extension FootpathMaterial {
    
    var imageName: String {
        
        switch self {
            
        case .cobble: return "circle"
        case .dirt: return "square"
        case .gravel: return "triangle"
        case .stone: return "oval"
        case .wood: return "seal"
        }
    }
}
