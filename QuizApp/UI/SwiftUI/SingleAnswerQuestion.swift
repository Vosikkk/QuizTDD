//
//  SingleAnswerQuestion.swift
//  QuizApp
//
//  Created by Саша Восколович on 20.03.2024.
//

import SwiftUI

struct SingleAnswerQuestion: View {
    
    let title: String
    let question: String
    let options: [String]
    let selection: (String) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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
           
            ForEach(options, id: \.self) { option in
                Button {
                    
                } label: {
                    HStack {
                        Circle()
                            .stroke(Color.secondary, lineWidth: 2.5)
                            .frame(width: 40, height: 40)
                        
                        Text(option)
                            .font(.title)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding()
                }
            }
            Spacer()
        }
    }
}

#Preview {
    SingleAnswerQuestion(
        title: "1 of 2",
        question: "What's Mike nationality?",
        options: [
            "Ukrainian",
            "American",
            "Greek",
            "Brazil"
        ],
        selection: { _ in })
}
