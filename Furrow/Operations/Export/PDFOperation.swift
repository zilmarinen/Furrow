//
//  PDFOperation.swift
//
//  Created by Zack Brown on 28/09/2021.
//

import Foundation
import Meadow
import PDFKit
import PeakOperation

class PDFOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<([GenericTile], [UVs], Data), Error> = Result { throw ResultError.noResult }
    public var output: Result<([GenericTile], [UVs], Data), Error> = Result { throw ResultError.noResult }
    
    override func execute() {
        
        do {
            
            let (tiles, uvs, imageData) = try input.get()
            
            guard let image = NSImage(data: imageData),
                  let page = PDFPage(image: image) else { throw ExportError.invalidData }
            
            let document = PDFDocument()
            
            document.insert(page, at: 0)
            
            guard let pdfData = document.dataRepresentation() else { throw ExportError.invalidData }
            
            output = .success((tiles, uvs, pdfData))
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
