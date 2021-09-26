//
//  TilemapExportOperation.swift
//
//  Created by Zack Brown on 24/09/2021.
//

import Foundation
import Meadow
import PeakOperation

class TilemapExportOperation: ConcurrentOperation, ProducesResult {
    
    public var output: Result<[String : FileWrapper], Error> = Result { throw ResultError.noResult }
    
    let url: URL
    let tilemap: Tilemap
    
    init(url: URL, tilemap: Tilemap) {
        
        self.url = url
        self.tilemap = tilemap
        
        super.init()
    }
    
    override func execute() {
        
        let footpathExport = TilesetExportOperation<Meadow.FootpathTilesetTile>(url: url, tiles: tilemap.footpath.tiles, tileset: Document.Constants.Folder.footpath)
        let surfaceExport = TilesetExportOperation<Meadow.SurfaceTilesetTile>(url: url, tiles: tilemap.surface.tiles, tileset: Document.Constants.Folder.surface)
        
        let group = DispatchGroup()
        var errors: [Error] = []
        var wrappers: [String : FileWrapper] = [:]
        
        group.enter()
        
        footpathExport.enqueue(on: internalQueue) { result in
            
            switch result {
                
            case .failure(let error):
                
                errors.append(error)
                
            case .success(let output):
                
                let (tileset, files) = output
                
                wrappers[tileset] = files
            }

            group.leave()
        }
        
        group.enter()
        
        surfaceExport.enqueue(on: internalQueue) { result in
            
            switch result {
                
            case .failure(let error):
                
                errors.append(error)
                
            case .success(let output):
                
                let (tileset, files) = output
                
                wrappers[tileset] = files
            }
            
            group.leave()
        }
        
        group.wait()
        
        output = errors.isEmpty ? .success(wrappers) : .failure(ImportError.missingFile)
        
        finish()
    }
}

