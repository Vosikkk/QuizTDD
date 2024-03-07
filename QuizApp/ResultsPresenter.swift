//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Саша Восколович on 03.03.2024.
//

import QuizEngine

struct ResultsPresenter {
    
    let result: Result<Question<String>, [String]>
    let questions: [Question<String>]
    let correctAnswers: [Question<String>: [String]]
    
    var title: String {
        "Result"
    }
    
    var summary: String {
        "You got \(result.score)/\(result.answers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return questions.map { question in
            guard let userAnswer = result.answers[question],
                  let correctAnswer = correctAnswers[question] else {
                fatalError("Couldn't find correct answer for question: \(question)")
            }
            return presentableAnswer(question, userAnswer, correctAnswer)
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
        return Set(correctAnswer) == Set(userAnswers) ? nil : formattedAnswer(userAnswers)
        //  correctAnswer == userAnswers ? nil : formattedAnswer(userAnswers)
    }
    
    private func formattedAnswer( _ answer: [String]) -> String {
        answer.joined(separator: ", ")
    }
}
