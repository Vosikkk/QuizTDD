//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Саша Восколович on 03.03.2024.
//

import UIKit
import QuizEngine

final class iOSUIKitViewControllerFactory: ViewControllerFactory {
    
    typealias Answers = [(question: Question<String>, answer: [String])]
    
    private let options: [Question<String>: [String]]
    
    private let correctAnswers: Answers
    
    private var questions: [Question<String>] {
        correctAnswers.map { $0.question }
    }
    
    
    init(options: [Question<String>: [String]], correctAnswers: Answers) {
        self.options = options
        self.correctAnswers = correctAnswers
    }
    
    
    func questionViewController(for question: Question<String>, 
                                answerCallback: @escaping ([String]) -> Void
    ) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for qoestion: \(question)")
        }
       return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    
    func resultsViewController(for userAnswers: Answers) -> UIViewController {
        let presenter = ResultsPresenter(userAnswers: userAnswers, correctAnswers: correctAnswers, scorer: BasicScore.score)
        let controller = ResultsViewController(summary: presenter.summary, answers: presenter.presentableAnswers)
        controller.title = presenter.title
        return controller
    }
    
    
    
    // MARK: - Helpers
    
    private func questionViewController(for question: Question<String>, 
                                        options: [String],
                                        answerCallback: @escaping ([String]) -> Void
    ) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return questionViewController(
                for: question,
                value: value,
                options: options,
                allowMultipleSelection: false, 
                answerCallback: answerCallback
            )
           
        case .multipleAnswer(let value):
            return questionViewController(
                for: question,
                value: value,
                options: options,
                allowMultipleSelection: true,
                answerCallback: answerCallback
            )
        }
    }
    
    private func questionViewController(for question: Question<String>,
                                        value: String, 
                                        options: [String],
                                        allowMultipleSelection: Bool,
                                        answerCallback: @escaping ([String]) -> Void
    ) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(
            question: value,
            options: options,
            allowMultipleSelection: allowMultipleSelection,
            selection: answerCallback
        )
        controller.title = presenter.title
        return controller
    }
}
