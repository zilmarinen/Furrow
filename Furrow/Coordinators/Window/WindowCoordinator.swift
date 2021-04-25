//
//  WindowCoordinator.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa

class WindowCoordinator: Coordinator<WindowController> {
    
    lazy var patternViewCoordinator: PatternViewCoordinator = {
        
        guard let viewController = controller.patternViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PatternViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: WindowController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        let tilemap = option as? Tilemap ?? Tilemap()
        
        start(child: patternViewCoordinator, with: tilemap)
    }
}

extension WindowCoordinator {
    
    override func export() throws {
        
        guard let tilemap = patternViewCoordinator.currentTilemap else { return }
        
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = "Export"
        
        panel.begin { (response) in
            
            guard response == .OK, let url = panel.urls.first else { return }
            
            var wrappers: [String : FileWrapper] = [:]
            
            var footpath: [String : FileWrapper] = [:]
            var surface: [String : FileWrapper] = [:]
            
            footpath[Document.Constants.Folder.tiles] = try? tilemap.footpath.tileset.export()
            
            surface[Document.Constants.Folder.edges] = try? tilemap.surface.edgeset.export()
            surface[Document.Constants.Folder.tiles] = try? tilemap.surface.tileset.export()
            
            wrappers[Document.Constants.Folder.footpath] = FileWrapper(directoryWithFileWrappers: footpath)
            wrappers[Document.Constants.Folder.surface] = FileWrapper(directoryWithFileWrappers: surface)
            
            let wrapper = FileWrapper(directoryWithFileWrappers: wrappers)
            
            try? wrapper.write(to: url, options: .atomic, originalContentsURL: nil)
        }
    }
}
