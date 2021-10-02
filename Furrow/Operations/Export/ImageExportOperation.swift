//
//  ImageExportOperation.swift
//
//  Created by Zack Brown on 25/09/2021.
//

import AppKit
import Euclid
import Meadow
import PeakOperation

class ImageExportOperation: ConcurrentOperation, ProducesResult {
    
    enum Constants {
        
        static let canvasSize = 4096.0
        static let tileSize = 128.0
        
        static let tilesPerRow = 32
        
        static let uvStep = (1.0 / Double(tilesPerRow))
    }

    public var output: Result<([GenericTile], [UVs], Data), Error> = Result { throw ResultError.noResult }

    let tiles: [GenericTile]

    init(tiles: [GenericTile]) {

        self.tiles = tiles

        super.init()
    }

    override func execute() {
        
        let canvasSize = NSSize(width: Constants.canvasSize / 2.0, height: Constants.canvasSize / 2.0)
        
        let canvas = NSImage(size: canvasSize)
        
        var uvs: [UVs] = []
        
        canvas.lockFocus()
        
        for index in tiles.indices {
            
            let image = tiles[index].image
            
            let y = Int(floor(Double(index / Constants.tilesPerRow)))
            let x = index - (y * Constants.tilesPerRow)
            
            let rect = NSRect(x: (Double(x) * Constants.tileSize), y: (Double(y) * Constants.tileSize), width: Constants.tileSize, height: Constants.tileSize)
            
            image.draw(in: rect)
            
            let vx = CGFloat(x)
            let vy = CGFloat(y)
            
            let start = Vector(x: Double(vx * Constants.uvStep), y: Double(1 - vy * Constants.uvStep), z: 0)
            let end = Vector(x: Double((vx + 1) * Constants.uvStep), y: Double(1 - ((vy + 1) * Constants.uvStep)), z: 0)
            
            uvs.append(UVs(start: start, end: end))
        }
        
        canvas.unlockFocus()
        
        guard let image = canvas.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            
            output = .failure(ExportError.missingFile)
            
            return finish()
        }
        
        let bitmap = NSBitmapImageRep(cgImage: image)
        
        bitmap.size = canvasSize
        
        guard let data = bitmap.representation(using: .png, properties: [:]) else {
            
            output = .failure(ExportError.missingFile)
            
            return finish()
        }
        
        output = .success((tiles, uvs, data))

        finish()
    }
}
