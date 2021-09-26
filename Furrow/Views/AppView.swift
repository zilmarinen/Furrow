//
//  AppView.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import SwiftUI

struct AppView: View {
    
    @ObservedObject var document: Document

    var body: some View {
        
        NavigationView {
            
            SidebarView(model: document.model)
                .frame(minWidth: 210)
                .toolbar {
                    
                    Button(action: toggleSidebar) {
                        
                        Image(systemName: "sidebar.left")
                            .help("Toggle Tileset Sidebar")
                    }
                    
                    Spacer()
                    
                    Menu {
                        
                        ForEach(Tileset.allCases, id: \.self) { tileset in
                            
                            Button(action: {
                            
                                document.model.add(tileset: tileset)
                            }) {
                                
                                Label("Add \(tileset.id.capitalized) tiles", systemImage: tileset.imageName)
                                    .help("Add \(tileset.id.capitalized) tiles")
                            }
                        }
                    }
                    label: {
                        
                        Label("Add tileset images", systemImage: "plus")
                            .help("Add tileset images")
                    }
                }
            
            Text("No Selection")
        }
    }
    
    private func toggleSidebar() {
        
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
}
