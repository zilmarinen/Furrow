//
//  WriteOperation.swift
//  Furrow
//
//  Created by Zack Brown on 26/09/2021.
//

import Foundation
import PeakOperation

class WriteOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<[String : FileWrapper], Error> = Result { throw ResultError.noResult }
    public var output: Result<Void, Error> = Result { throw ResultError.noResult }
    
    let url: URL
    
    init(url: URL) {
        
        self.url = url
        
        super.init()
    }
    
    override func execute() {
        
        do {
            
            let wrappers = try input.get()
            
            let wrapper = FileWrapper(directoryWithFileWrappers: wrappers)
            
            try wrapper.write(to: url, options: .atomic, originalContentsURL: url)
            
            output = .success(())
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
