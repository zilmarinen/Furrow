//
//  AddTilesView.swift
//
//  Created by Zack Brown on 26/09/2021.
//

import SwiftUI

struct AddTilesView: View {
    
    @ObservedObject var model: AppViewModel
    
    var body: some View {
        
        VStack {
            
            if let image = model.material.image {
            
                Image(nsImage: image)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: FurrowApp.Constants.minimumImageSize, height: FurrowApp.Constants.minimumImageSize)
                    .cornerRadius(FurrowApp.Constants.cornerRadius)
                    .padding(FurrowApp.Constants.padding)
            }
            
            Text("Missing Seasonal Tiles")
                .font(.title)
                .padding(FurrowApp.Constants.edgeInsets)
            
            Text("There are currently no seasonal tiles in this \(model.season.id) tileset.")
                .font(.body)
                .padding(.bottom, FurrowApp.Constants.padding)
            
            Button {
                
                guard let tileset = model.tileset else { return }
                
                model.add(tileset: tileset)
                
            } label: {
                
                Label("Add tileset images", systemImage: "plus")
                    .help("Add tileset images")
                    .padding()
            }
            .buttonStyle(LargeButtonStyle())
        }
    }
}
