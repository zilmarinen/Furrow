//
//  PatternViewCoordinator.swift
//  Furrow
//
//  Created by Zack Brown on 23/03/2021.
//

import Cocoa

class PatternViewCoordinator: Coordinator<PatternViewController> {
    
    override init(controller: PatternViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        //
        print("start")
    }
}
