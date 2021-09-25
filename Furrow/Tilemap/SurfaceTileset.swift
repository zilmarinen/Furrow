//
//  SurfaceTileset.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import AppKit
import Foundation
import Meadow

class SurfaceTileset: ObservableObject {
    
    @Published var tiles: [SurfaceTile]
    
    init() {
        
        self.tiles = []
    }
    
    init(fileWrapper: FileWrapper) throws {
        
        guard let wrappers = fileWrapper.fileWrappers else { throw CocoaError(.fileReadCorruptFile) }
        
        var items: [SurfaceTile] = []
        
        for (key, value) in wrappers {
            
            guard let data = value.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
            
            let tile = try SurfaceTile(filename: key, data: data)
            
            items.append(tile)
        }
        
        self.tiles = items
    }
    
    func fileWrapper() throws -> FileWrapper {
     
        var wrappers: [String : FileWrapper] = [:]
        
        for tile in tiles {
            
            guard let data = tile.image.tiffRepresentation else { throw CocoaError(.fileReadCorruptFile) }
            
            let filename = Document.Constants.Folder.surface + "_\(tile.identifier)_\(tile.season.rawValue)_\(tile.overlay.rawValue)_\(tile.variation)." + Document.Constants.FileFormat.png
            
            wrappers[filename] = .init(regularFileWithContents: data)
        }
        
        return .init(directoryWithFileWrappers: wrappers)
    }
}

extension SurfaceTileset {
    
    func tiles(with overlay: SurfaceOverlay) -> [SurfaceTile] {
        
        return tiles.filter { $0.overlay == overlay }
    }
    
    func tiles(with season: Season, overlay: SurfaceOverlay) -> [SurfaceTile] {
        
        return tiles.filter { $0.season == season && $0.overlay == overlay }
    }
}
