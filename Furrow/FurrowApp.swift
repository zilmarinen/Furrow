//
//  FurrowApp.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import SwiftUI

@main
struct FurrowApp: App {
    
    let model = AppViewModel()
    
    var body: some Scene {
        
        DocumentGroup(newDocument: Document(model: model)) { file in
            
            AppView(document: file.document)
        }
        .commands {
            
            SidebarCommands()
            
            CommandGroup(after: .saveItem) {
                
                Button(action: {
                    
                    model.export()
                    
                }, label: {
                    
                    Text("Export")
                        .help("Export tilemap and tileset")
                })
                .keyboardShortcut("E")
            }
        }
    }
}
