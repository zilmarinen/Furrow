//
//  Document.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa

class Document: NSDocument {
    
    enum Constants {
        
        static let windowIndentifier = NSStoryboard.SceneIdentifier("WindowController")
        
        static let sceneGraphWrapperIdentifier = "scene.graph"
    }
    
    let coordinator: WindowCoordinator

    override init() {
        
        guard let windowController = NSStoryboard.main.instantiateController(withIdentifier: Constants.windowIndentifier) as? WindowController else { fatalError("Invalid view controller hierarchy") }
        
        coordinator = WindowCoordinator(controller: windowController)
        
        super.init()
    }

    override class var autosavesInPlace: Bool {
        
        return true
    }

    override func makeWindowControllers() {
        
        self.addWindowController(coordinator.controller)
        
        coordinator.start(with: nil)
    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        
        //
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        return FileWrapper(directoryWithFileWrappers: [:])
    }
}
