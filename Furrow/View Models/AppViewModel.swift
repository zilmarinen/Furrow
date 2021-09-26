//
//  AppViewModel.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import AppKit
import Combine
import Meadow
import SwiftUI

class AppViewModel: ObservableObject {
    
    @Published var tileset: Tileset? = .surface(.grass)
    @Published var selectedTab: Tab = .tilemap
    @Published var season: Season = .spring
    @Published var material: SurfaceMaterial = .dirt
    @Published var showIdentifiers = true
    
    @Published var tilemap: Tilemap
    
    private var tilemapSink: AnyCancellable? = nil
    
    lazy var operationQueue: OperationQueue = {
        
        let queue = OperationQueue()
        
        queue.maxConcurrentOperationCount = 1
        
        return queue
    }()
    
    init() {
        
        tilemap = Tilemap()
        
        startObserving()
    }
    
    init(fileWrapper: FileWrapper) throws {
        
        tilemap = try Tilemap(fileWrapper: fileWrapper)
        
        startObserving()
    }
    
    func startObserving() {
        
        tilemapSink = tilemap.objectWillChange.sink { [weak self] (_) in
            
            self?.objectWillChange.send()
        }
    }
}

extension AppViewModel {
    
    func add(tileset: Tileset) {
        
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.canCreateDirectories = false
        panel.allowedFileTypes = ["png"]
        
        switch panel.runModal() {
            
        case .OK:
            
            switch tileset {
                
            case .footpath:
                
                let operation = TilesetImportOperation<FootpathTile>(urls: panel.urls, tiles: tilemap.footpath.tiles)
                
                operation.enqueue(on: operationQueue) { result in
                    
                    switch result {
                        
                    case .failure: break
                    case .success(let tiles):
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self = self else { return }
                            
                            self.tilemap.footpath.tiles.append(contentsOf: tiles)
                        }
                    }
                }
                
            case .surface:
                
                let operation = TilesetImportOperation<SurfaceTile>(urls: panel.urls, tiles: tilemap.surface.tiles)
                
                operation.enqueue(on: operationQueue) { result in
                    
                    switch result {
                        
                    case .failure: break
                    case .success(let tiles):
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self = self else { return }
                            
                            self.tilemap.surface.tiles.append(contentsOf: tiles)
                        }
                    }
                }
            }
            
        default: break
        }
    }
    
    func remove(tile: TilesetTile, from tileset: Tileset) {
        
        switch tileset {
            
        case .footpath:
            
            guard let tile = tile as? FootpathTile,
                  let index = tilemap.footpath.tiles.firstIndex(of: tile) else { return }
            
            tilemap.footpath.tiles.remove(at: index)
            
        default:
            
            guard let tile = tile as? SurfaceTile,
                  let index = tilemap.surface.tiles.firstIndex(of: tile) else { return }
            
            tilemap.surface.tiles.remove(at: index)
        }
    }
}

extension AppViewModel {
    
    func export() {
        
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.canCreateDirectories = true
        panel.prompt = "Export"
        
        switch panel.runModal() {
            
        case .OK:
            
            guard let url = panel.url else { return }
            
            viewState = .exporting
            
            let exportOperation = TilemapExportOperation(url: url, tilemap: tilemap)
            let writeOperation = WriteOperation(url: url);
            
            exportOperation.passesResult(to: writeOperation).enqueue(on: operationQueue) { result in
                
                switch result {
                    
                case .failure: break
                case .success: break
                }
            
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else { return }
                
                    self.viewState = .idle
                }
            }
            
        default: break
        }
    }
}
