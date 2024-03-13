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
    
    func answer(for question: Question, completion: @escaping (Answer) -> Void)
    
    
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)])
    
    @available(*, deprecated, message: "use diddidCompleteQuiz(withAnswers:) instead")
    func handle(result: Result<Question, Answer>)
}

#warning("Delete this at some point")
public extension QuizDelegate {
    func didCompleteQuiz(withAnswers: [(question: Question, answer: Answer)]) {}
}
