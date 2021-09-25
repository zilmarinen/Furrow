//
//  SurfaceOverlay.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import Meadow

extension SurfaceOverlay {
    
    var imageName: String {
        
        switch self {
            
        case .grass: return "circle"
        case .undergrowth: return "square"
        case .water: return "triangle"
        }
    }
}
