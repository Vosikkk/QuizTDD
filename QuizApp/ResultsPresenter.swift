//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Саша Восколович on 03.03.2024.
//

import QuizEngine

struct ResultsPresenter {
    
    let result: Result<Question<String>, [String]>
    let correctAnswers: [Question<String>: [String]]
    
    
    var summary: String {
        "You got \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return result.answers.map { (question, userAnswers) in
            guard let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn't find correct answer for question: \(question)")
            }
            return presentableAnswer(question, userAnswers, correctAnswer)
        }
    }
    
    private func presentableAnswer(_ question: Question<String>, _ userAnswers: [String], _ correctAnswer: [String]) -> PresentableAnswer {
        
        switch question {
        case .singleAnswer(let value), .multipleAnswer(let value):
            return PresentableAnswer(
                question: value,
                answer: formattedAnswer(correctAnswer),
                wrongAnswer: formattedWrongAnswer(userAnswers, correctAnswer)
            )
        }
    }
    
    private func formattedWrongAnswer(_ userAnswers: [String], _ correctAnswer: [String]) -> String? {
         correctAnswer == userAnswers ? nil : formattedAnswer(userAnswers)
    }
    
    private func formattedAnswer( _ answer: [String]) -> String {
        answer.joined(separator: ", ")
    }
}
