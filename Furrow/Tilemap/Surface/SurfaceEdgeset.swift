//
//  SurfaceEdgeset.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa
import Foundation
import Meadow

class SurfaceEdgeset: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case edges = "e"
    }
    
    var edges: [SurfaceEdge]

    init() {

        edges = []
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        edges = try container.decode([SurfaceEdge].self, forKey: .edges)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(edges, forKey: .edges)
    }
}

extension SurfaceEdgeset {
    
    func read(fileWrapper: FileWrapper) throws {

        guard let wrapper = fileWrapper.fileWrappers?[Document.Constants.Folder.edges] else { throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil) }

        let decoder = JSONDecoder()

        let jsonFilename = Document.Constants.Folder.surface + "_" + Document.Constants.Filename.edgemap + "." + Document.Constants.FileFormat.json

        guard let jsonData = wrapper.fileWrappers?[jsonFilename]?.regularFileContents else { throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil) }

        let nodes = try decoder.decode([SurfaceEdge].self, from: jsonData)

        for index in 0..<nodes.count {
            
            let node = nodes[index]

            let imageFilename = "\(node.pattern)_\(index + 1)." + Document.Constants.FileFormat.png

            guard let imageData = wrapper.fileWrappers?[imageFilename]?.regularFileContents,
                  let image = NSImage(data: imageData) else { continue }

            node.image = image

            edges.append(node)
        }
    }

    func write() throws -> FileWrapper {

        let encoder = JSONEncoder()

        var wrapper: [String : FileWrapper] = [:]

        let jsonData = try encoder.encode(edges)

        let jsonFilename = Document.Constants.Folder.surface + "_" + Document.Constants.Filename.edgemap + "." + Document.Constants.FileFormat.json

        wrapper[jsonFilename] = FileWrapper(regularFileWithContents: jsonData)

        for index in 0..<edges.count {
            
            let node = edges[index]

            guard let image = node.image,
                  let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { continue }

            let bitmap = NSBitmapImageRep(cgImage: cgImage)

            bitmap.size = image.size

            guard let imageData = bitmap.representation(using: .png, properties: [:]) else { continue }

            let imageFilename = "\(node.pattern)_\(index + 1)." + Document.Constants.FileFormat.png

            wrapper[imageFilename] = FileWrapper(regularFileWithContents: imageData)
        }

        return FileWrapper(directoryWithFileWrappers: wrapper)
    }

    func export() throws -> FileWrapper {

        let encoder = JSONEncoder()

        var wrapper: [String : FileWrapper] = [:]

        let images = edges.compactMap { $0.image }

        guard let (uvs, imageData) = NSImage.blit(images: images), uvs.count == edges.count else { throw NSError(domain: NSOSStatusErrorDomain, code: writErr, userInfo: nil) }

        for index in 0..<uvs.count {

            edges[index].uvs = uvs[index]
        }

        let jsonData = try encoder.encode(edges)

        let imageFilename = Document.Constants.Folder.surface + "_" + Document.Constants.Filename.edgeset + "." + Document.Constants.FileFormat.png
        let jsonFilename = Document.Constants.Folder.surface + "_" + Document.Constants.Filename.edgemap + "." + Document.Constants.FileFormat.json

        wrapper[imageFilename] = FileWrapper(regularFileWithContents: imageData)
        wrapper[jsonFilename] = FileWrapper(regularFileWithContents: jsonData)

        return FileWrapper(directoryWithFileWrappers: wrapper)
    }
}
