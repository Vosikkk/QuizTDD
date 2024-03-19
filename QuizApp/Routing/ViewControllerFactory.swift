//
//  ViewControllerFactory.swift
//  QuizApp
//
//  Created by Саша Восколович on 03.03.2024.
//

import QuizEngine
import UIKit

protocol ViewControllerFactory {
    
    typealias Answers = [(question: Question<String>, answers: [String])]
    
    func questionViewController(for question: Question<String>, answerCallback: @escaping ([String]) -> Void) -> UIViewController
    
    func resultsViewController(for userAnswers: Answers) -> UIViewController
    
    func resultViewController(for result: Result<Question<String>, [String]>) -> UIViewController
}

