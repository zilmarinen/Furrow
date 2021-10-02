//
//  TilesetBlobView.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Meadow
import SwiftUI

struct TilesetBlobView: View {
    
    @ObservedObject var model: AppViewModel
    
    @State private(set) var showIdentifiers = false

    var body: some View {
        
        if model.seasonalTiles.isEmpty {
            
            AddTilesView(model: model)
        }
        else {
            
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
                                
                                if let image = model.blobTiles[identifier]?.image {
                                 
                                    TilesetBlobViewTile(identifier: identifier, image: image, showIdentifier: $model.showIdentifiers)
                                }
                                else {
                                    
                                    Color.clear
                                }
                            }
                        }
                    }
                }
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }
}
