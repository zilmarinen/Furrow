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
    
    enum ViewState {
        
        case idle
        case importing(progress: Progress)
        case exporting(progress: Progress)
    }
    
    @Published var viewState: ViewState = .idle
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
    
    var seasonalTiles: [TilesetTile] {
        
        switch tileset {
            
        case .footpath(let material): return tilemap.footpath.tiles(with: season, material: material)
        case .surface(let overlay): return tilemap.surface.tiles(with: season, overlay: overlay)
        default: return []
        }
    }
    
    var blobTiles: [Int: TilesetTile] {
        
        return seasonalTiles.reduce(into: [Int : TilesetTile]()) { result, element in
            
            result[element.identifier] = element
        }
    }
    
    func count(tileset: Tileset) -> Int {
        
        switch tileset {
            
        case .footpath(let tileType): return tilemap.footpath.tiles(with: tileType).count
        case .surface(let overlay): return tilemap.surface.tiles(with: overlay).count
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
                
                let progress = operation.enqueueWithProgress(on: operationQueue) { result in
                    
                    switch result {
                        
                    case .failure: break
                    case .success(let tiles):
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self = self else { return }
                            
                            self.tilemap.footpath.tiles.append(contentsOf: tiles)
                            
                            self.viewState = .idle
                        }
                    }
                }
                
                viewState = .importing(progress: progress)
                
            case .surface:
                
                let operation = TilesetImportOperation<SurfaceTile>(urls: panel.urls, tiles: tilemap.surface.tiles)
                
                let progress = operation.enqueueWithProgress(on: operationQueue) { result in
                    
                    switch result {
                        
                    case .failure: break
                    case .success(let tiles):
                        
                        DispatchQueue.main.async { [weak self] in
                            
                            guard let self = self else { return }
                            
                            self.tilemap.surface.tiles.append(contentsOf: tiles)
                            
                            self.viewState = .idle
                        }
                    }
                }
                
                viewState = .importing(progress: progress)
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
            
            let exportOperation = TilemapExportOperation(url: url, tilemap: tilemap)
            let writeOperation = WriteOperation(url: url);
            
            let progress = exportOperation.passesResult(to: writeOperation).enqueueWithProgress(on: operationQueue) { result in
            
                DispatchQueue.main.async { [weak self] in
                    
                    guard let self = self else { return }
                
                    self.viewState = .idle
                }
            }
            
            viewState = .exporting(progress: progress)
            
        default: break
        }
    }
}
