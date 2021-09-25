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
    
    public var output: Result<Void, Error> = Result { throw ResultError.noResult }
    
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
        
        for season in Season.allCases {
            
            let seasonalTiles = tiles.filter { $0.season == season }
            
            let images = seasonalTiles.map { $0.image }
            
            guard !images.isEmpty else { continue }
            
            group.enter()
            
            let imageOperation = TilesetImageExportOperation(images: images)
            let tileOperation = TileExportOperation<T>(tiles: seasonalTiles)
            let fileOperation = FileExportOperation<T>(url: url, season: season, tileset: tileset)
            
            print("Enqueing \(season.id.capitalized) image export operation")
            
            imageOperation.passesResult(to: tileOperation).passesResult(to: fileOperation).enqueue(on: internalQueue) { result in
                
                self.dispatchQueue.async(flags: .barrier) {
                
                    if case let .failure(error) = result {
                        
                        errors.append(error)
                    }
                    print("\(season.id.capitalized) image export operation complete")
                    group.leave()
                }
            }
        }
        
        group.wait()
        
        output = .success(())
        
        finish()
    }
}
