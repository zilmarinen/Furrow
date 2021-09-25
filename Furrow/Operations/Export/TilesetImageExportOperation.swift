//
//  TilesetImageExportOperation.swift
//
//  Created by Zack Brown on 25/09/2021.
//

import AppKit
import Euclid
import Meadow
import PeakOperation

class TilesetImageExportOperation: ConcurrentOperation, ProducesResult {
    
    enum Constants {
        
        static let canvasSize = 8192.0
        static let tileSize = 128.0
        
        static let tilesPerRow = 64
        
        static let uvStep = (1.0 / Double(tilesPerRow))
    }

    public var output: Result<([UVs], Data), Error> = Result { throw ResultError.noResult }

    let images: [NSImage]

    init(images: [NSImage]) {

        self.images = images

        super.init()
    }

    override func execute() {
        print("Exporting Tileset with \(images.count) images")
        let canvasSize = NSSize(width: Constants.canvasSize / 2.0, height: Constants.canvasSize / 2.0)
        
        let canvas = NSImage(size: canvasSize)
        
        var uvs: [UVs] = []
        
        canvas.lockFocus()
        
        for index in images.indices {
            
            let image = images[index]
            
            let y = Int(floor(Double(index / Constants.tilesPerRow)))
            let x = index - (y * Constants.tilesPerRow)
            
            print("[\(x), \(y)] -> \(index)")
            
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
        print("Finished writing tileset")
        output = .success((uvs, data))

        finish()
    }
}
