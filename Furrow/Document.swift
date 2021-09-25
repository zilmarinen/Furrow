//
//  Document.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    
    static var model: UTType { UTType(importedAs: "com.so.furrow.model") }
}

class Document: FileDocument, ObservableObject {
    
    enum Constants {
        
        enum FileFormat {
            
            static let json = "json"
            static let png = "png"
        }
        
        enum Folder {
            
            static let footpath = "footpath"
            static let surface = "surface"
        }
        
        enum Filename {
            
            static let tilemap = "tilemap"
            static let tileset = "tileset"
        }
    }
    
    static var readableContentTypes: [UTType] { [.model] }
    
    @ObservedObject var model: AppViewModel

    init(model: AppViewModel) {
        
        self.model = model
    }

    required init(configuration: ReadConfiguration) throws {
        
        model = try AppViewModel(fileWrapper: configuration.file)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        
        return try model.tilemap.fileWrapper()
    }
}
