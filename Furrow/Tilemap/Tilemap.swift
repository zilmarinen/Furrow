//
//  Tilemap.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import Combine
import SwiftUI

class Tilemap: ObservableObject {
    
    static let blob: [[Int]] = [[0, 2, 78, 206, 142, 12, 0],
                                [4, 6, 47, 127, 157, 7, 8],
                                [71, 143, 15, 43, 95, 207, 140],
                                [103, 223, 141, 70, 239, 191, 29],
                                [39, 59, 31, 111, 255, 159, 13],
                                [3, 14, 79, 175, 63, 25, 5],
                                [0, 1, 35, 27, 11, 10, 9]]
    
    @Published var footpath: FootpathTileset
    @Published var surface: SurfaceTileset
    
    private var footpathSink: AnyCancellable? = nil
    private var surfaceSink: AnyCancellable? = nil
    
    init() {
        
        footpath = FootpathTileset()
        surface = SurfaceTileset()
        
        startObserving()
    }
    
    init(fileWrapper: FileWrapper) throws {
        
        guard let footpathWrapper = fileWrapper.fileWrappers?[Document.Constants.Folder.footpath],
              let surfaceWrapper = fileWrapper.fileWrappers?[Document.Constants.Folder.surface] else { throw CocoaError(.fileReadCorruptFile) }
        
        footpath = try FootpathTileset(fileWrapper: footpathWrapper)
        surface = try SurfaceTileset(fileWrapper: surfaceWrapper)
        
        startObserving()
    }
    
    func fileWrapper() throws -> FileWrapper {
        
        var wrappers: [String : FileWrapper] = [:]
        
        wrappers[Document.Constants.Folder.footpath] = try footpath.fileWrapper()
        wrappers[Document.Constants.Folder.surface] = try surface.fileWrapper()
        
        return .init(directoryWithFileWrappers: wrappers)
    }
    
    func startObserving() {
        
        footpathSink = footpath.objectWillChange.sink { [weak self] (_) in
            
            self?.objectWillChange.send()
        }
        
        surfaceSink = surface.objectWillChange.sink { [weak self] (_) in
            
            self?.objectWillChange.send()
        }
    }
}
