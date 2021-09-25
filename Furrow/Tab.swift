//
//  Tab.swift
//
//  Created by Zack Brown on 24/09/2021.
//

enum Tab: CaseIterable, Identifiable {
    
    case tilemap
    case tileset
    
    var id: String {
        
        switch self {
            
        case .tilemap: return "Tilemap"
        case .tileset: return "Tileset"
        }
    }
}
