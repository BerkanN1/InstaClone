//
//  ButtonModifier.swift
//  Flexigram
//
//  Created by BERKAN NALBANT on 1.08.2021.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(minWidth:0,maxWidth: .infinity)
            .frame(height:20)
            .padding()
            .foregroundColor(.white)
            .font(.system(size: 14,weight: .bold))
            .background(Color.black)
            .cornerRadius(5.0)
        
    }
  
}

