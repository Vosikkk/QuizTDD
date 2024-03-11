//
//  Router.swift
//  QuizEngine
//
//  Created by Саша Восколович on 26.02.2024.
//

import Foundation

public protocol QuizDelegate {
    
    associatedtype Question: Hashable
    associatedtype Answer
    
    func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
    func handle(result: Result<Question, Answer>)
}



@available(*, deprecated)
public protocol Router {
    
    associatedtype Question: Hashable
    associatedtype Answer
    
    func routeTo(question: Question, answerCallback: @escaping (Answer) -> Void)
    func routeTo(result: Result<Question, Answer>)
}
