//
//  TilesetView.swift
//
//  Created by Zack Brown on 22/09/2021.
//

import Meadow
import SwiftUI

struct TilesetView: View {
    
    @ObservedObject var model: AppViewModel
     
    var body: some View {
        
        switch model.selectedTab {
            
        case .tilemap:
            
            TilesetBlobView(model: model)
            
        case .tileset:
            
            TilesetScrollView(model: model)
        }
    }
}
