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
            HeaderView(title: title, question: question)
           
            ForEach(store.options.indices, id: \.self) { index in
                MultipleTextSelectionCell(option: $store.options[index])
            }
            Spacer()
            submitButton
                .padding()
        }
    }
    
    private var submitButton: some View {
         Button {
            store.submit()
         } label: {
             Text("Submit")
                 .foregroundStyle(.white)
                 .hAlign(.center)
                 .fillView(.blue)
         }
        .buttonStyle(PlainButtonStyle())
        .disabled(!store.canSubmit)
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
