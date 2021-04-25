//
//  SurfaceTileset.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa
import Foundation
import Meadow

class SurfaceTileset: Codable {
    
    enum CodingKeys: String, CodingKey {
        
        case tiles = "t"
    }
    
    var tiles: [SurfaceTile]

    init() {

        tiles = []
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)

        tiles = try container.decode([SurfaceTile].self, forKey: .tiles)
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(tiles, forKey: .tiles)
    }
}

extension SurfaceTileset {
    
    func read(fileWrapper: FileWrapper) throws {

        guard let wrapper = fileWrapper.fileWrappers?[Document.Constants.Folder.tiles] else { throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil) }

        let decoder = JSONDecoder()

        let jsonFilename = Document.Constants.Folder.surface + "_" + Document.Constants.Filename.tilemap + "." + Document.Constants.FileFormat.json

        guard let jsonData = wrapper.fileWrappers?[jsonFilename]?.regularFileContents else { throw NSError(domain: NSOSStatusErrorDomain, code: readErr, userInfo: nil) }

        let nodes = try decoder.decode([SurfaceTile].self, from: jsonData)

        for node in nodes {

            let imageFilename = "\(node.pattern)_\(node.variation)." + Document.Constants.FileFormat.png

            guard let imageData = wrapper.fileWrappers?[imageFilename]?.regularFileContents,
                  let image = NSImage(data: imageData) else { continue }

            node.image = image

            tiles.append(node)
        }
    }

    func write() throws -> FileWrapper {

        let encoder = JSONEncoder()

        var wrapper: [String : FileWrapper] = [:]

        let jsonData = try encoder.encode(tiles)

        let jsonFilename = Document.Constants.Folder.surface + "_" + Document.Constants.Filename.tilemap + "." + Document.Constants.FileFormat.json

        wrapper[jsonFilename] = FileWrapper(regularFileWithContents: jsonData)

        for node in tiles {

            guard let image = node.image,
                  let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { continue }

            let bitmap = NSBitmapImageRep(cgImage: cgImage)

            bitmap.size = image.size

            guard let imageData = bitmap.representation(using: .png, properties: [:]) else { continue }

            let imageFilename = "\(node.pattern)_\(node.variation)." + Document.Constants.FileFormat.png

            wrapper[imageFilename] = FileWrapper(regularFileWithContents: imageData)
        }

        return FileWrapper(directoryWithFileWrappers: wrapper)
    }

    func export() throws -> FileWrapper {

        let encoder = JSONEncoder()

        var wrapper: [String : FileWrapper] = [:]

        let images = tiles.compactMap { $0.image }

        guard let (uvs, imageData) = NSImage.blit(images: images), uvs.count == tiles.count else { throw NSError(domain: NSOSStatusErrorDomain, code: writErr, userInfo: nil) }

        for index in 0..<uvs.count {

            tiles[index].uvs = uvs[index]
        }

        let jsonData = try encoder.encode(tiles)

        let imageFilename = Document.Constants.Folder.surface + "_" + Document.Constants.Filename.tileset + "." + Document.Constants.FileFormat.png
        let jsonFilename = Document.Constants.Folder.surface + "_" + Document.Constants.Filename.tilemap + "." + Document.Constants.FileFormat.json

        wrapper[imageFilename] = FileWrapper(regularFileWithContents: imageData)
        wrapper[jsonFilename] = FileWrapper(regularFileWithContents: jsonData)

        return FileWrapper(directoryWithFileWrappers: wrapper)
    }
}
