//
//  TilesetBlobView.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Meadow
import SwiftUI

struct TilesetBlobView: View {
    
    enum Constants {
        
        static let imageSize = 128.0
        static let rowWidth = imageSize * 7.0
        static let rowHeight = rowWidth / 7.0
        static let wrapperHeight = rowHeight * 7.0
        
        static let padding = 8.0
        
        static let edgeInsets = EdgeInsets(top: 2, leading: Constants.padding, bottom: 2, trailing: Constants.padding)
    }
    
    @ObservedObject var model: AppViewModel
    
    @State private(set) var showIdentifiers = false
    
    private let tiles: [Int : NSImage]
    
    init(model: AppViewModel) {
        
        self.model = model
        
        switch model.tileset {
            
        case .footpath(let tileType):
            
            self.tiles = model.tilemap.footpath.tiles(with: model.season, tileType: tileType).blob
            
        case .surface(let overlay):
            
            self.tiles = model.tilemap.surface.tiles(with: model.season, overlay: overlay).blob
        
        default: self.tiles = [:]
        }
    }
    
    var body: some View {
        
        ZStack {
            
            if let image = model.material.image {
                
                Image(nsImage: image)
                    .renderingMode(.original)
                    .resizable()
            }
         
            VStack(alignment: .leading, spacing: 0) {
            
                ForEach(0..<Tilemap.blob.count, id: \.self) { row in
                
                    HStack(alignment: .center, spacing: 0) {
                        
                        ForEach(0..<Tilemap.blob[row].count, id: \.self) { column in
                            
                            let identifier = Tilemap.blob[row][column]
                            
                            TilesetBlobViewTile(identifier: identifier, image: tiles[identifier], showIdentifier: $model.showIdentifiers)
                        }
                    }
                    .frame(height: Constants.rowHeight)
                }
            }
        }
        .frame(width: Constants.rowWidth, height: Constants.wrapperHeight)
    }
}
