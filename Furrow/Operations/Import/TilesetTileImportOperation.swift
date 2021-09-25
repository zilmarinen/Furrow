//
//  TilesetTileImportOperation.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import AppKit
import Foundation
import Meadow
import PeakOperation

class TilesetTileImportOperation<T: TilesetTile>: ConcurrentOperation, ProducesResult {
    
    public var output: Result<T, Error> = Result { throw ResultError.noResult }
    
    let url: URL
    
    required init(url: URL) {
        
        self.url = url
        
        super.init()
    }
    
    override func execute() {
        
        do {
            
            let data = try Data(contentsOf: url)
            
            let tile = try T(filename: url.lastPathComponent, data: data)
            
            output = .success(tile)
            
            return finish()
        }
        catch {
            
            output = .failure(error)
            
            return finish()
        }
    }
}
