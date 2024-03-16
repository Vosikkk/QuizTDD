//
//  DelegateSpy.swift
//  QuizEngine
//
//  Created by Саша Восколович on 17.03.2024.
//

import Foundation
import QuizEngine

class DelegateSpy: QuizDelegate {
    
    var questionAsked: [String] = []
    var answerCompletions: [(String) -> Void] = []
    var completedQuizzes: [[(String, String)]] = []
    
    func answer(for question: String, completion: @escaping (String) -> Void) {
        questionAsked.append(question)
        self.answerCompletions.append(completion)
    }
    
    func didCompleteQuiz(withAnswers answers: [(question: String, answer: String)]) {
        completedQuizzes.append(answers)
    }
}
