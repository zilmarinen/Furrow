//
//  ButtonStyle.swift
//
//  Created by Zack Brown on 26/09/2021.
//

import SwiftUI

struct LargeButtonStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        
        configuration.label
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.accentColor : Color.accentColor.opacity(0.7))
            .cornerRadius(FurrowApp.Constants.cornerRadius)
            .padding(FurrowApp.Constants.edgeInsets)
    }
}
