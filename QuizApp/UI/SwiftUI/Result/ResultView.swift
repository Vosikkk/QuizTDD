//
//  ResultView.swift
//  QuizApp
//
//  Created by Саша Восколович on 23.03.2024.
//

import SwiftUI

struct ResultView: View {
    
    let title: String
    let summary: String
    let answers: [PresentableAnswer]
    let playAgain: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            HeaderView(title: title, subtitle: summary)
            List(answers, id: \.question) { model in
                ResultAnswerCell(model: model)
            }
            .listStyle(.inset)
            Spacer()
            
            RoundedButton(title: "Play again", action: playAgain)
                .padding()
        }
    }
    private let spacing: CGFloat = 0
}

#Preview {
    TestResultView()
}

struct TestResultView: View {
   
    @State var playAgainCount: Int = 0
    
    var body: some View {
        
        VStack {
            ResultView(
                title: "Test",
                summary: "You got 2/5 correct",
                answers: [
                    .init(
                        question: "What's the answer to question #001?",
                        answer: "A correct answer",
                        wrongAnswer: "A wrong answer"
                    ),
                    .init(
                        question: "What's the answer to question #002?",
                        answer: "A correct answer",
                        wrongAnswer: nil
                    ),
                    .init(
                        question: "What's the anwser to question #003?",
                        answer: "A correct answer",
                        wrongAnswer: "A wrong answer"
                    ),
                    .init(
                        question: "What's the answer to question #004?",
                        answer: "A correct answer",
                        wrongAnswer: nil
                    ),
                    .init(
                        question: "What's the answer to question #005?",
                        answer: "A correct answer",
                        wrongAnswer: "A wrong answer"
                    )
                ],
                playAgain: {  playAgainCount += 1 }
            )
            
            Text("Play again count: \(playAgainCount)")
        }
    }
}
