//
//  NSImage.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa
import Foundation
import Meadow

extension NSImage {
    
    enum Constants {
        
        static let size: Double = 2048
    }
    
    static func blit(images: [NSImage]) -> ([UVs], Data)? {
        
        let size = Int(ceil(sqrt(Double(images.count))))
        
        let imageSize = floor(Constants.size / Double(size))
        let canvasSize = NSSize(width: Constants.size, height: Constants.size)
        let divisor = (1 / canvasSize.width) * CGFloat(imageSize)

        let blit = NSImage(size: canvasSize)
        
        blit.lockFocus()
        
        var uvs: [UVs] = []
        
        for i in 0..<images.count {
            
            let y = Int(floor(Double(i / size)))
            let x = i - (y * size)
            
            let image = images[i]
            
            let rect = NSRect(x: (Double(x) * imageSize), y: (Double(y) * imageSize), width: imageSize, height: imageSize)
            
            image.draw(in: rect)
            
            let vx = CGFloat(x)
            let vy = CGFloat(y)
            
            let start = Vector(x: Double(vx * divisor), y: Double(1 - vy * divisor), z: 0)
            let end = Vector(x: Double((vx + 1) * divisor), y: Double(1 - ((vy + 1) * divisor)), z: 0)
            
            uvs.append(UVs(start: start, end: end))
        }
        
        blit.unlockFocus()
        
        guard let image = blit.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        
        let bitmap = NSBitmapImageRep(cgImage: image)
        
        bitmap.size = canvasSize
        
        guard let data = bitmap.representation(using: .png, properties: [:]) else { return nil }

        return (uvs, data)
    }
}
