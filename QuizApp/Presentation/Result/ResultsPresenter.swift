//
//  ResultsPresenter.swift
//  QuizApp
//
//  Created by Саша Восколович on 03.03.2024.
//

import QuizEngine

final class ResultsPresenter {
    
    typealias Answers = [(question: Question<String>, answers: [String])]
    typealias Scorer = ([[String]], [[String]]) -> Int
    
    private let userAnswers: Answers
    private let correctAnswers: Answers
    private let scorer: Scorer
    
    
    init(userAnswers: Answers, correctAnswers: Answers, scorer: @escaping Scorer) {
        self.userAnswers = userAnswers
        self.correctAnswers = correctAnswers
        self.scorer = scorer
    }
    
    
    var title: String {
        "Result"
    }
    
    private var score: Int {
        scorer(userAnswers.map { $0.answers }, correctAnswers.map { $0.answers })
    }
    
    var summary: String {
        "You got \(score)/\(userAnswers.count) correct"
    }
    
    var presentableAnswers: [PresentableAnswer] {
        return zip(userAnswers, correctAnswers).map { userAnswer, correctAnswer in
            return presentableAnswer(userAnswer.question, userAnswer.answers, correctAnswer.answers)
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
