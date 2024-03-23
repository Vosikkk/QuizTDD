//
//  MultipleQuestionAnswer.swift
//  QuizApp
//
//  Created by Саша Восколович on 22.03.2024.
//

import SwiftUI

struct MultipleAnswerQuestion: View {
    
    let title: String
    let question: String
    @State var store: MultipleSelectionStore
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(title: title, subtitle: question)
           
            ForEach(store.options.indices, id: \.self) { index in
                MultipleTextSelectionCell(option: $store.options[index])
            }
            Spacer()
            RoundedButton(title: "Submit", isEnabled: store.canSubmit) {
                
            }
            .padding()
        }
    }
}

#Preview {
    MultipleAnswerQuestionTestView()
}

struct MultipleAnswerQuestionTestView: View {
    
    @State var selection: [String] = ["none"]
    
    var body: some View {
        VStack {
            MultipleAnswerQuestion(
                title: "1 of 2",
                question: "What's Mike nationality?",
                store:  .init(options: [
                    "Ukrainian",
                    "American",
                    "Greek",
                    "Brazil"
                ], handler: { selection = $0 })
            )
            
            Text("Last submission " + selection.joined(separator: ", "))
        }
    }
}

