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
            HeaderView(title: title, question: question)
           
            ForEach(options, id: \.self) { option in
                SingleTextSelectionCell(text: option, selection: {
                    selection(option)
                })
            }
            Spacer()
        }
    }
}

#Preview {
    SingleAnswerQuestionTestView()
}

struct SingleAnswerQuestionTestView: View {
    
    @State var selection: String = "none"
    
    var body: some View {
        VStack {
            SingleAnswerQuestion(
                title: "1 of 2",
                question: "What's Mike nationality?",
                options: [
                    "Ukrainian",
                    "American",
                    "Greek",
                    "Brazil"
                ],
            selection: { selection = $0 })
            
            Text("Last selection " + selection)
        }
    }
}
