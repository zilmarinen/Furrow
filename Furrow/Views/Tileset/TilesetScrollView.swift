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
        
        static let minimumSize = 128.0
        static let maximumSize = 512.0
    }
    
    @ObservedObject var model: AppViewModel
    
    private let columns = [ GridItem(.adaptive(minimum: Constants.minimumSize, maximum: Constants.maximumSize)) ]
    
    var body: some View {
        
        ScrollView {
            
            LazyVGrid(columns: columns, spacing: Constants.padding) {
                
                ForEach(model.seasonalTiles, id: \.self) { tile in
                    
                    TilesetScrollViewTile(tile: tile, material: model.material)
                        .background(Color.secondary)
                        .cornerRadius(8)
                    .contextMenu {
                        
                        Text("\(tile.identifier) - \(tile.variation)")
                        
                        Divider()
                        
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
