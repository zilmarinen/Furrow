//
//  FurrowApp.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import SwiftUI

@main
struct FurrowApp: App {
    
    enum Constants {
        
        static let minimumImageSize = 128.0
        static let maximumImageSize = 512.0
        
        static let padding = 8.0
        static let cornerRadius = 8.0
        
        static let edgeInsets = EdgeInsets(top: 2, leading: padding, bottom: 2, trailing: padding)
    }
    
    var body: some Scene {
        
        DocumentGroup(newDocument: Document(model: AppViewModel())) { file in
            
            AppView(document: file.document)
                .focusedValue(\.document, file.$document)
        }
        .commands {
            
            SidebarCommands()
            
            CommandGroup(after: .saveItem) {
                
                ExportCommand()
            }
        }
    }
}
