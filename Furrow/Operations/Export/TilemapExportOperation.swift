//
//  TilemapExportOperation.swift
//
//  Created by Zack Brown on 24/09/2021.
//

import Foundation
import Meadow
import PeakOperation

class TilemapExportOperation: ConcurrentOperation, ProducesResult {
    
    public var output: Result<Void, Error> = Result { throw ResultError.noResult }
    
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
        
        group.enter()
        print("Enqueing Footpath export operation")
        footpathExport.enqueue(on: internalQueue) { result in
            
            if case let .failure(error) = result {
                
                errors.append(error)
            }
            print("Footpath export operation complete")
            group.leave()
        }
        
        group.enter()
        print("Enqueing Surface export operation")
        surfaceExport.enqueue(on: internalQueue) { result in
            
            if case let .failure(error) = result {
                
                errors.append(error)
            }
            print("Surface export operation complete")
            group.leave()
        }
        
        group.wait()
        
        output = errors.isEmpty ? .success(()) : .failure(ImportError.missingFile)
        
        finish()
    }
}

