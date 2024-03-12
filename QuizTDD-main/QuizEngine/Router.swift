//
//  Router.swift
//  QuizEngine
//
//  Created by Саша Восколович on 26.02.2024.
//

import Foundation


@available(*, deprecated)
public protocol Router {
    
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
