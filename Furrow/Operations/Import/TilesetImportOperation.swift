//
//  TilesetImportOperation.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Foundation
import PeakOperation

class TilesetImportOperation<T: TilesetTile>: ConcurrentOperation, ProducesResult {
    
    public var output: Result<[T], Error> = Result { throw ResultError.noResult }
    
    private let dispatchQueue = DispatchQueue(label: "TilesetImportOperation", attributes: .concurrent)
    
    private let urls: [URL]
    private let tiles: [T]
    
    init(urls: [URL], tiles: [T]) {
        
        self.urls = urls
        self.tiles = tiles
        
        super.init()
    }
    
    override func execute() {
        
        guard !urls.isEmpty else {
            
            output = .failure(ImportError.missingFile)
            
            return finish()
        }
        
        var results: [T] = []
        
        let group = DispatchGroup()
        
        for url in urls {
            
            group.enter()
            
            let operation = TilesetTileImportOperation<T>(url: url)
            
            operation.enqueue(on: internalQueue) { result in
                
                self.dispatchQueue.async(flags: .barrier) {
                
                    if case let .success(tile) = result {
                    
                        if !self.tiles.contains(tile) {

                            results.append(tile)
                        }
                    }
                    
                    group.leave()
                }
            }
        }
        
        group.wait()
        
        output = !results.isEmpty ? .success(results) : .failure(ImportError.missingFile)
        
        finish()
    }
}
