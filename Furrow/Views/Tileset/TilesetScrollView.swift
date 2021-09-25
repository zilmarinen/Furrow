//
//  TilesetScrollView.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Meadow
import SwiftUI

struct TilesetScrollView: View {
    
    enum Constants {
        
        static let padding = 16.0
        
        static let minimumWidth = 128.0
        static let maximumWidth = 512.0
    }
    
    @ObservedObject var model: AppViewModel
    
    private let tiles: [TilesetTile]
    
    private let columns = [ GridItem(.adaptive(minimum: Constants.minimumWidth, maximum: Constants.maximumWidth)) ]
    
    init(model: AppViewModel) {
        
        self.model = model
        
        switch model.tileset {
            
        case .footpath(let tileType):
            
            self.tiles = model.tilemap.footpath.tiles(with: model.season, tileType: tileType).sorted { $0.identifier < $1.identifier && $0.variation < $1.variation }
            
        case .surface(let overlay):
            
            self.tiles = model.tilemap.surface.tiles(with: model.season, overlay: overlay).sorted { $0.identifier < $1.identifier }
            
        default: self.tiles = []
        }
    }
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: columns, spacing: Constants.padding) {
                
                ForEach(tiles, id: \.self) { tile in
                    
                    TilesetScrollViewTile(tile: tile, material: model.material)
                    .contextMenu {
                        
                        Button(action: {
                        
                            guard let tileset = model.tileset else { return }
                            
                            model.remove(tile: tile, from: tileset)
                            
                        }) {
                            
                            Label("Delete", systemImage: "trash")
                                .help("Delete this tile variation")
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}
