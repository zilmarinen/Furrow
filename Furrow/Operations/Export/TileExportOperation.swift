//
//  TileExportOperation.swift
//
//  Created by Zack Brown on 25/09/2021.
//

import Foundation
import Meadow
import PeakOperation

class TileExportOperation<T: Meadow.TilesetTile>: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<([GenericTile], [UVs], Data), Error> = Result { throw ResultError.noResult }
    public var output: Result<([T], Data), Error> = Result { throw ResultError.noResult }
    
    override func execute() {
        
        do {
            
            let (tiles, uvs, data) = try input.get()
            
            guard tiles.count == uvs.count else { throw ExportError.missingFile }
            
            var results: [T] = []
            
            for index in tiles.indices {
                
                let tile = tiles[index]
                let uv = uvs[index]
                
                let result = try T(pattern: tile.identifier, season: tile.season, uvs: uv, rawType: tile.rawType)
                
                results.append(result)
            }
            
            output = .success((results, data))
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
