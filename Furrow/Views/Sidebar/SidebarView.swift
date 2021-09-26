//
//  SidebarView.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import Meadow
import SwiftUI

struct SidebarView: View {
    
    @ObservedObject var model: AppViewModel
    
    var body: some View {
        
        List {
            
            Text("Footpath")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
            
            ForEach(FootpathTileType.allCases, id: \.self) { tileType in
                
                NavigationLink(destination: destinationView, tag: .footpath(tileType), selection: $model.tileset) {
                    
                    SidebarItemView(model: .init(title: tileType.id.capitalized, imageName: tileType.imageName, count: model.count(tileset: .footpath(tileType))))
                }
            }
            
            Text("Surface")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
            
            ForEach(SurfaceOverlay.allCases, id: \.self) { overlay in
                
                NavigationLink(destination: destinationView, tag: .surface(overlay), selection: $model.tileset) {
                    
                    SidebarItemView(model: .init(title: overlay.id.capitalized, imageName: overlay.imageName, count: model.count(tileset: .surface(overlay))))
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
    
    @ViewBuilder
    var destinationView: some View {
     
        TilesetView(model: model)
            .toolbar {
                
            Picker("Toggle between tilemap and tileset view", selection: $model.selectedTab) {
                
                ForEach(Tab.allCases, id: \.self) { tab in
                    
                    Text(tab.id.capitalized)
                        .tag(tab)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
                
            Spacer()
            
            Menu {
                    
                Picker("Material", selection: $model.material) {
                    
                    ForEach(SurfaceMaterial.allCases, id: \.self) { material in
                        
                        Text(material.id.capitalized)
                    }
                }
                
                Divider()
                
                Picker("Season", selection: $model.season) {
                    
                    ForEach(Season.allCases, id: \.self) { season in
                        
                        Text(season.id.capitalized)
                    }
                }
                
                Divider()
                
                if model.selectedTab == .tilemap {
                    
                    Toggle("Show Tile Identifiers", isOn: $model.showIdentifiers)
                }
            }
            label: {
                Label("Change view settings", systemImage: "slider.horizontal.3")
            }
        }
    }
}
