//
//  Document.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa

class Document: NSDocument {
    
    enum Constants {
            
        static let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        static let windowIndentifier = NSStoryboard.SceneIdentifier("WindowController")
        
        enum FileFormat {
            
            static let json = "json"
            static let png = "png"
        }
        
        enum Folder {
            
            static let footpath = "Footpath"
            static let surface = "Surface"
            
            static let edges = "Edges"
            static let tiles = "Tiles"
        }
        
        enum Filename {
            
            static let edgemap = "Edgemap"
            static let edgeset = "Edgeset"
            
            static let tilemap = "Tilemap"
            static let tileset = "Tileset"
        }
    }
    
    let coordinator: WindowCoordinator
    
    var tilemap: Tilemap?

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
        
        coordinator.start(with: tilemap)
        
        tilemap = nil
    }

    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        
        guard let footpathWrapper = fileWrapper.fileWrappers?[Constants.Folder.footpath],
              let surfaceWrapper = fileWrapper.fileWrappers?[Constants.Folder.surface] else { throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil) }
        
        self.tilemap = Tilemap()
        
        guard let tilemap = tilemap else { throw NSError(domain: NSOSStatusErrorDomain, code: writErr, userInfo: nil) }
        
        try tilemap.footpath.tileset.read(fileWrapper: footpathWrapper)
        try tilemap.surface.edgeset.read(fileWrapper: surfaceWrapper)
        try tilemap.surface.tileset.read(fileWrapper: surfaceWrapper)
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        guard let tilemap = coordinator.patternViewCoordinator.currentTilemap else { throw NSError(domain: NSOSStatusErrorDomain, code: writErr, userInfo: nil) }
        
        var wrappers: [String : FileWrapper] = [:]
        
        var footpath: [String : FileWrapper] = [:]
        var surface: [String : FileWrapper] = [:]
        
        footpath[Constants.Folder.tiles] = try tilemap.footpath.tileset.write()
        
        surface[Constants.Folder.edges] = try tilemap.surface.edgeset.write()
        surface[Constants.Folder.tiles] = try tilemap.surface.tileset.write()
        
        wrappers[Constants.Folder.footpath] = FileWrapper(directoryWithFileWrappers: footpath)
        wrappers[Constants.Folder.surface] = FileWrapper(directoryWithFileWrappers: surface)
        
        return FileWrapper(directoryWithFileWrappers: wrappers)
    }
}
