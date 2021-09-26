//
//  TilesetScrollViewTile.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Meadow
import SwiftUI

struct TilesetScrollViewTile: View {
    
    let tile: TilesetTile
    let material: SurfaceMaterial
    
    var body: some View {
     
        VStack {
            
            ZStack {
                
                if let image = material.image {
                
                    Image(nsImage: image)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: FurrowApp.Constants.minimumImageSize, height: FurrowApp.Constants.minimumImageSize)
                }
            
                if let image = tile.image {
                
                    Image(nsImage: image)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: FurrowApp.Constants.minimumImageSize, height: FurrowApp.Constants.minimumImageSize)
                }
            }
            .cornerRadius(FurrowApp.Constants.cornerRadius)
            .padding(FurrowApp.Constants.padding)
            
            Text("\(tile.identifier) - \(tile.variation)")
                .font(.system(size: 10, weight: .regular))
                .padding(FurrowApp.Constants.edgeInsets)
                .foregroundColor(Color.black)
                .background(Color.secondary)
                .cornerRadius(FurrowApp.Constants.cornerRadius)
                .padding(.bottom, FurrowApp.Constants.padding)
        }
    }
}
