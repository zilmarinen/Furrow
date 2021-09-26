//
//  TilesetScrollView.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Meadow
import SwiftUI

struct TilesetScrollView: View {
    
    @ObservedObject var model: AppViewModel
    
    private let columns = [ GridItem(.adaptive(minimum: FurrowApp.Constants.minimumImageSize, maximum: FurrowApp.Constants.maximumImageSize)) ]
    
    var body: some View {
        
        if model.seasonalTiles.isEmpty {
            
            AddTilesView(model: model)
        }
        else {
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: FurrowApp.Constants.padding * 2.0) {
                    
                    ForEach(model.seasonalTiles, id: \.self) { tile in
                        
                        TilesetScrollViewTile(tile: tile, material: model.material)
                            .background(Color.secondary)
                            .cornerRadius(FurrowApp.Constants.cornerRadius)
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
}
