//
//  TilesetScrollViewTile.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Meadow
import SwiftUI

struct TilesetScrollViewTile: View {
    
    enum Constants {
        
        static let buttonSize = Constants.padding * 2.0
        static let imageSize = 128.0
        
        static let padding = 8.0
        
        static let edgeInsets = EdgeInsets(top: 2, leading: Constants.padding, bottom: 2, trailing: Constants.padding)
    }
    
    let tile: TilesetTile
    let material: SurfaceMaterial
    
    var body: some View {
     
        VStack {
            
            ZStack {
                
                if let image = material.image {
                
                    Image(nsImage: image)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                }
            
                if let image = tile.image {
                
                    Image(nsImage: image)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                }
            }
            .cornerRadius(8)
            .padding(.horizontal, Constants.padding)
            
            Text("\(tile.identifier) - \(tile.variation)")
                .font(.system(size: 10, weight: .regular))
                .foregroundColor(Color.black)
                .padding(Constants.edgeInsets)
                .background(Color.secondary)
                .cornerRadius(8)
        }
        
    }
}
