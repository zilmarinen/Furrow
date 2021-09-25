//
//  SidebarItemView.swift
//
//  Created by Zack Brown on 23/09/2021.
//

import SwiftUI

struct SidebarItemView: View {
    
    let model: SidebarItemModel
    
    var body: some View {
        
        HStack {
            
            Label(model.title, systemImage: model.imageName)
            Spacer()
            BadgeView(model: .init(title: model.count.description, color: .accentColor))
        }
    }
}
