//
//  ResultAnswerCell.swift
//  QuizApp
//
//  Created by Саша Восколович on 27.03.2024.
//

import SwiftUI

struct ResultAnswerCell: View {
    
    let model: PresentableAnswer
    
    var body: some View {
        VStack(alignment: .leading, spacing: Constants.spacing) {
            Text(model.question)
                .font(.title)
            Text(model.answer)
                .font(.title2)
                .foregroundStyle(.green)
            if let wrongAnswer = model.wrongAnswer {
                Text(wrongAnswer)
                    .font(.title2)
                    .foregroundStyle(.red)
            }
        }
        .padding(.vertical, Constants.inset)
    }
    
    private struct Constants {
        static let spacing: CGFloat = 0
        static let inset: CGFloat = 7
    }
}

#Preview {
    ResultAnswerCell(model: .init(question: "What's the answer to question #001?", answer: "A correct answer", wrongAnswer: nil))
}
