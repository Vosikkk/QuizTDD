//
//  iOSViewControllerFactory.swift
//  QuizApp
//
//  Created by Саша Восколович on 03.03.2024.
//

import UIKit
import QuizEngine

class iOSViewControllerFactory: ViewControllerFactory {
    
    private let options: [Question<String>: [String]]
    private let questions: [Question<String>]
    
    init(questions: [Question<String>], options: [Question<String>: [String]]) {
        self.questions = questions
        self.options = options
    }
    
    
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        guard let options = options[question] else {
            fatalError("Couldn't find options for qoestion: \(question)")
        }
       return questionViewController(for: question, options: options, answerCallback: answerCallback)
    }
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController {
        UIViewController()
    }
    
    
    
    private func questionViewController(for question: Question<String>, options: [String],  answerCallback: @escaping ([String]) -> Void) -> UIViewController {
        switch question {
        case .singleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowMultipleSelection: false, answerCallback: answerCallback)
           
        case .multipleAnswer(let value):
            return questionViewController(for: question, value: value, options: options, allowMultipleSelection: true ,answerCallback: answerCallback)
        }
    }
    
    private func questionViewController(for question: Question<String>, value: String, options: [String],  allowMultipleSelection: Bool, answerCallback: @escaping ([String]) -> Void) -> QuestionViewController {
        let presenter = QuestionPresenter(questions: questions, question: question)
        let controller = QuestionViewController(question: value, options: options, allowMultipleSelection: allowMultipleSelection, selection: answerCallback)
        controller.title = presenter.title
        return controller
    }
    
}
