//
//  HeaderView.swift
//  QuizApp
//
//  Created by Саша Восколович on 21.03.2024.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .foregroundStyle(.blue)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top)
            
            Text(subtitle)
                .font(.largeTitle)
                .fontWeight(.medium)
        }
        .hAlign(.leading)
        .padding()
    }
}

#Preview {
    HeaderView(title: "Test", subtitle: "is the rasha terrorist state? Rhetorical question")
}
