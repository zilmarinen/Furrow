//
//  TilesetBlobViewTile.swift
//
//  Created by Zack Brown on 24/09/2021.
//

import SwiftUI

struct TilesetBlobViewTile: View {
    
    let identifier: Int
    let image: NSImage?
    @Binding var showIdentifier: Bool
    
    var body: some View {
        
        ZStack {
            
            if let image = image {

                Image(nsImage: image)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: TilesetBlobView.Constants.imageSize, height: TilesetBlobView.Constants.imageSize)
            }
            else {

                Color.clear
                    .frame(width: TilesetBlobView.Constants.imageSize, height: TilesetBlobView.Constants.imageSize)
            }

            if showIdentifier {

                Text("\(identifier)")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(Color.black)
                    .padding(TilesetBlobView.Constants.edgeInsets)
                    .background(Color.secondary)
                    .cornerRadius(8)
            }
        }
    }
}
