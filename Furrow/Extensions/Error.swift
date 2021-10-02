//
//  Error.swift
//
//  Created by Zack Brown on 23/09/2021.
//

enum ImportError: Error {
    
    case incorrectFilenameFormat
    case missingFile
}

enum ExportError: Error {
    
    case missingFile
    case invalidData
}
