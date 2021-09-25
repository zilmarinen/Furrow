//
//  FootpathTileset.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import AppKit
import Foundation
import Meadow

class FootpathTileset: ObservableObject {
    
    @Published var tiles: [FootpathTile]
    
    init() {
        
        self.tiles = []
    }
    
    init(fileWrapper: FileWrapper) throws {
        
        guard let wrappers = fileWrapper.fileWrappers else { throw CocoaError(.fileReadCorruptFile) }
        
        var items: [FootpathTile] = []
        
        for (key, value) in wrappers {
            
            guard let data = value.regularFileContents else { throw CocoaError(.fileReadCorruptFile) }
            
            let tile = try FootpathTile(filename: key, data: data)
            
            items.append(tile)
        }
        
        self.tiles = items
    }
    
    func fileWrapper() throws -> FileWrapper {
     
        var wrappers: [String : FileWrapper] = [:]
        
        for tile in tiles {
            
            guard let data = tile.image.tiffRepresentation else { throw CocoaError(.fileReadCorruptFile) }
            
            let filename = Document.Constants.Folder.footpath + "_\(tile.identifier)_\(tile.season.rawValue)_\(tile.tileType.rawValue)_\(tile.variation)." + Document.Constants.FileFormat.png
            
            wrappers[filename] = .init(regularFileWithContents: data)
        }
        
        return .init(directoryWithFileWrappers: wrappers)
    }
}

extension FootpathTileset {
    
    func tiles(with tileType: FootpathTileType) -> [FootpathTile] {
        
        return tiles.filter { $0.tileType == tileType }
    }
    
    func tiles(with season: Season, tileType: FootpathTileType) -> [FootpathTile] {
        
        return tiles.filter { $0.season == season && $0.tileType == tileType }
    }
}
