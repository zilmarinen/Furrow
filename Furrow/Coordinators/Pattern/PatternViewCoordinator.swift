//
//  PatternViewCoordinator.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa
import Meadow

class PatternViewCoordinator: Coordinator<PatternViewController> {
    
    var currentTilemap: Tilemap?
    
    override init(controller: PatternViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        guard let tilemap = option as? Tilemap else { fatalError("Invalid start option") }
        
        currentTilemap = tilemap
    }
}

extension PatternViewCoordinator {
    
    override func `import`(footpath tileType: Int) {
        
        guard let tilemap = currentTilemap,
              let tileType = FootpathTileType(rawValue: tileType) else { return }
                
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.canCreateDirectories = false
        panel.allowedFileTypes = ["png"]
        
        panel.begin { [weak self] (response) in
            
            guard let self = self else { return }
            
            guard response == .OK else { return }
            
            for url in panel.urls {
                
                guard let image = NSImage(contentsOf: url),
                      let components = url.lastPathComponent.components(separatedBy: ".").first?.components(separatedBy: "_") else { continue }
                
                guard let pattern = Int(components[1]),
                      let variation = Int(components[2]) else { continue }
                
                let tile = FootpathTile(pattern: pattern, tileType: tileType, variation: variation, image: image)
                
                tilemap.footpath.tileset.tiles.append(tile)
            }
        }
    }
    
    override func `import`(surface tilemapType: NSResponder.TilemapType, environment: NSResponder.EnvironmentType) {
        
        guard let tilemap = currentTilemap else { return }
                
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.canCreateDirectories = false
        panel.allowedFileTypes = ["png"]
        
        panel.begin { [weak self] (response) in
            
            guard let self = self else { return }
            
            guard response == .OK else { return }
            
            for url in panel.urls {
                
                guard let image = NSImage(contentsOf: url),
                      let components = url.lastPathComponent.components(separatedBy: ".").first?.components(separatedBy: "_") else { continue }
                
                guard let pattern = Int(components[1]) else { continue }
                
                switch tilemapType {
                
                case .edges:
                    
                    let edge = SurfaceEdge(pattern: pattern, image: image)
                    
                    tilemap.surface.edgeset.edges.append(edge)
                    
                case .tiles:
                    
                    guard let variation = Int(components[2]) else { continue }
                    
                    let tile = SurfaceTile(pattern: pattern, variation: variation, image: image)
                    
                    tilemap.surface.tileset.tiles.append(tile)
                }
            }
        }
    }
}
