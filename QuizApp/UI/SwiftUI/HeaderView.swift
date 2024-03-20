//
//  HeaderView.swift
//  QuizApp
//
//  Created by Саша Восколович on 21.03.2024.
//

import SwiftUI

struct HeaderView: View {
    
    let title: String
    let question: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .foregroundStyle(.blue)
                .font(.headline)
                .fontWeight(.medium)
                .padding(.top)
            
            Text(question)
                .font(.largeTitle)
                .fontWeight(.medium)
        }
        .padding()
    }
}

#Preview {
    HeaderView(title: "HZ", question: "rasha is terrorist state? Rhetorical question")
}
