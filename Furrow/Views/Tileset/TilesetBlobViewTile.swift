//
//  TilesetBlobViewTile.swift
//
//  Created by Zack Brown on 24/09/2021.
//

import SwiftUI

struct TilesetBlobViewTile: View {
    
    enum Constants {
        
        static let edgeInsets = EdgeInsets(top: 2, leading: 8, bottom: 2, trailing: 8)
    }
    
    let identifier: Int
    let image: NSImage
    @Binding var showIdentifier: Bool
    
    var body: some View {
        
        ZStack {
            
            Image(nsImage: image)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(1, contentMode: .fit)

            if showIdentifier {

                Text("\(identifier)")
                    .font(.system(size: 10, weight: .regular))
                    .foregroundColor(Color.black)
                    .padding(Constants.edgeInsets)
                    .background(Color.secondary)
                    .cornerRadius(8)
            }
        }
    }
}
