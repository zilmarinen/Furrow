//
//  ExportCommand.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import SwiftUI

struct ExportCommand: View {
    
    @FocusedBinding(\.document)
    
    var document: Document?
    
    var body: some View {
        
        Button(action: {
            
            document?.model.export()
            
        }, label: {
            
            Text("Export")
                .help("Export tilemap and tileset")
        })
            .keyboardShortcut("E")
    }
}
