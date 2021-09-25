//
//  SurfaceMaterial.swift
//
//  Created by Zack Brown on 24/09/2021.
//

import AppKit
import Meadow

extension SurfaceMaterial {
    
    var image: NSImage? { MDWImage.asset(named: "surface_\(id)", in: Map.bundle) }
}
