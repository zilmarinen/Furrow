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
        
        start(child: patternViewCoordinator, with: option)
    }
}
