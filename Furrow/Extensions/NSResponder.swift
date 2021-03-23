//
//  NSResponder.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa

@objc extension NSResponder {
    
    var responder: NSResponder? { nextResponder }
}
