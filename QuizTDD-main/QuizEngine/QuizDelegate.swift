//
//  QuizDelegate.swift
//  QuizEngine
//
//  Created by Саша Восколович on 13.03.2024.
//

import Foundation

public protocol QuizDelegate {
    
    associatedtype Question: Hashable
    associatedtype Answer
    
    func handle(question: Question, answerCallback: @escaping (Answer) -> Void)
    func handle(result: Result<Question, Answer>)
}
