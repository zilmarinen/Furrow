//
//  TilesetExportOperation.swift
//
//  Created by Zack Brown on 25/09/2021.
//

import AppKit
import Foundation
import Meadow
import PeakOperation

class TilesetExportOperation<T: Meadow.TilesetTile>: ConcurrentOperation, ProducesResult {
    
    public var output: Result<(String, FileWrapper), Error> = Result { throw ResultError.noResult }
    
    private let dispatchQueue = DispatchQueue(label: "TilesetExportOperation", attributes: .concurrent)
    
    let url: URL
    let tiles: [GenericTile]
    let tileset: String
    
    init(url: URL, tiles: [FootpathTile], tileset: String) {
        
        self.url = url
        self.tiles = tiles.map { GenericTile(tile: $0) }
        self.tileset = tileset
        
        super.init()
    }
    
    init(url: URL, tiles: [SurfaceTile], tileset: String) {
        
        self.url = url
        self.tiles = tiles.map { GenericTile(tile: $0) }
        self.tileset = tileset
        
        super.init()
    }
    
    override func execute() {
        
        let group = DispatchGroup()
        var errors: [Error] = []
        var wrappers: [String : FileWrapper] = [:]
        
        for season in Season.allCases {
            
            let seasonalTiles = tiles.filter { $0.season == season }
            
            guard !seasonalTiles.isEmpty else { continue }
            
            group.enter()
            
            let imageOperation = ImageExportOperation(tiles: seasonalTiles)
            let tileOperation = TileExportOperation<T>()
            let encodingOperation = TileEncodingOperation<T>(season: season, tileset: tileset)
            
            imageOperation.passesResult(to: tileOperation).passesResult(to: encodingOperation).enqueue(on: internalQueue) { result in
                
                self.dispatchQueue.async(flags: .barrier) {
                    
                    switch result {
                        
                    case .failure(let error):
                        
                        errors.append(error)
                        
                    case .success(let files):
                        
                        files.forEach { wrappers[$0] = $1 }
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.wait()
        
        output = errors.isEmpty ? .success((tileset, FileWrapper(directoryWithFileWrappers: wrappers))) : .failure(ImportError.missingFile)
        
        finish()
    }
}
