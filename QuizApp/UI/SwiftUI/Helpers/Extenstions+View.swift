//
//  Extenstions+View.swift
//  QuizApp
//
//  Created by Саша Восколович on 23.03.2024.
//

import SwiftUI


extension View {
    func hAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func fillView(_ color: Color) -> some View {
           self
               .padding(.vertical, 10)
               .background {
                   RoundedRectangle(cornerRadius: 15, style: .continuous)
                       .fill(color)
               }
       }
}
