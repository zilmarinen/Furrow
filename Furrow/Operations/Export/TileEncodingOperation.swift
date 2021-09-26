//
//  TileEncodingOperation.swift
//
//  Created by Zack Brown on 25/09/2021.
//

import Foundation
import Meadow
import PeakOperation

class TileEncodingOperation<T: Meadow.TilesetTile>: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<([T], Data), Error> = Result { throw ResultError.noResult }
    public var output: Result<[String : FileWrapper], Error> = Result { throw ResultError.noResult }
    
    let season: Season
    let tileset: String
    
    init(season: Season, tileset: String) {
        
        self.season = season
        self.tileset = tileset
        
        super.init()
    }
    
    override func execute() {
        
        do {
            
            var wrappers: [String : FileWrapper] = [:]
            
            let (tiles, imageData) = try input.get()
            
            let encoder = JSONEncoder()
            
            let tileData = try encoder.encode(tiles)
            
            let tilemapFilename =  tileset + "_" + season.id.lowercased() + "_" + Document.Constants.Filename.tileset + "." + Document.Constants.FileFormat.png
            let tilesetFilename = tileset + "_" + season.id.lowercased() + "_" + Document.Constants.Filename.tilemap + "." + Document.Constants.FileFormat.json
            
            wrappers[tilemapFilename] = FileWrapper(regularFileWithContents: imageData)
            wrappers[tilesetFilename] = FileWrapper(regularFileWithContents: tileData)
            
            output = .success(wrappers)
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
